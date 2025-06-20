//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation
import CoreML
import Foundation

/// Regression을 이용하여 코드 추측
final class ChordClassificationWithRegression: ChordClassificationUseCase {
  private let model: ChordClassifierRegressionModel?
  private let chromaExtractor = ChromaExtractor()
  private let labels: [Chord?] = [.A, .B7, .C, .E, .G, nil]

  init() {
    do {
      model = try ChordClassifierRegressionModel()
    } catch {
      model = nil
      Logger.e(error.localizedDescription)
    }
  }

  /// Silence인 경우 nil 반환
  func run(
    buffer: AVAudioPCMBuffer,
    windowSize: Int,
    activeChords: [Chord] = Chord.allCases,
    minVolumeThreshold: Double = 0.025,
    minConfidenceThreshold: Float = 0.5
  ) -> (chord: Chord?, confidence: Float)? {
    guard let data = buffer.floatChannelData?[0] else { return nil }
    let frameLength = Int(buffer.frameLength)

    // RMS : min volume threshold
    var sumSquares: Double = 0
    for i in 0 ..< frameLength {
      let sample = Double(data[i])
      sumSquares += sample * sample
    }
    let rms = sqrt(sumSquares / Double(frameLength))
    if rms < minVolumeThreshold {
      return (nil, 1.0)
    }

    let audioArray = Array(UnsafeBufferPointer(start: data, count: frameLength))
    let chroma = chromaExtractor.extract(
      from: audioArray,
      sampleRate: Float(buffer.format.sampleRate),
      windowSize: windowSize,
      hopSize: Int(windowSize / 2)
    )

    // Model 입력 변환
    guard let input = convertSwiftArrayToMLMultiArray(chroma),
          let prediction = try? model?.prediction(dense_input: input)
    else {
      return nil
    }

    // ['A', 'B7', 'C', 'E', 'G', 'Silence']
    Logger.d("prediction : \(prediction.Identity)")
    let results = convertMLMultiArrayToSwiftArray(prediction.Identity)
    if let maxIndex = results.firstIndex(of: results.max() ?? 0.0) {
      let confidence = results[maxIndex]
      if confidence < minConfidenceThreshold { return nil }
      if labels.count != results.count {
        Logger.e("GuitarChordClassifier의 결과물과 output 배열의 크기가 다릅니다.")
        return nil
      }
      let chord = labels[maxIndex]!
      if !activeChords.contains(chord) { return nil }
      return (chord, confidence)
    } else {
      print("배열이 비어있거나 값을 찾을 수 없습니다.")
    }
    return nil
  }

  func convertSwiftArrayToMLMultiArray(_ array: [Float]) -> MLMultiArray? {
    let rows = 1
    let columns = array.count
    guard let mlArray = try? MLMultiArray(shape: [NSNumber(value: rows), NSNumber(value: columns)], dataType: .float32) else {
      return nil
    }

    for (index, value) in array.enumerated() {
      mlArray[[0, NSNumber(value: index)]] = NSNumber(value: value)
    }

    return mlArray
  }

  private func convertMLMultiArrayToSwiftArray(_ multiArray: MLMultiArray) -> [Float] {
    guard multiArray.dataType == .float32 || multiArray.dataType == .double else {
      return []
    }

    var swiftArray: [Float] = []
    for i in 0 ..< multiArray.count {
      swiftArray.append(multiArray[i].floatValue)
    }
    return swiftArray
  }
}
