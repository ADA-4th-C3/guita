//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation
import Foundation
import CoreML

final class ChordClassificationWithML {
  private let model: GuitarChordClassifier?
  private let chromaExtractor = ChromaExtractor()
  // ['A', 'B7', 'C', 'E', 'G', 'Silence']
  private let output: [Chord?] = [.A, .B7, .C, .E, .G, nil]
  
  init () {
    do {
      model = try GuitarChordClassifier()
    } catch {
      model = nil
      Logger.e(error.localizedDescription)
    }
  }
  
  /// Silence인 경우 nil 반환
  func run(
    buffer: AVAudioPCMBuffer,
    windowSize: Int,
    minConfidenceThreshold: Float = 0.5
  ) -> (chord: Chord?, confidence: Float, pixel: CVPixelBuffer)? {
    guard let data = buffer.floatChannelData?[0] else { return nil }
    let frameLength = Int(buffer.frameLength)
    let audioArray = Array(UnsafeBufferPointer(start: data, count: frameLength))
    let chroma = chromaExtractor.extract(
      from: audioArray,
      sampleRate: Float(buffer.format.sampleRate),
      windowSize: windowSize,
      hopSize: Int(windowSize / 2)
    )
    
    // [Float] → [[Float]] (128 x 128 reshape)
    let reshapedChroma: [[Float]]
    if chroma.count >= 128 * 128 {
      reshapedChroma = stride(from: 0, to: 128 * 128, by: 128).map {
        Array(chroma[$0 ..< $0 + 128])
      }
    } else {
      // padding with zeros if not enough
      let padded = chroma + Array(repeating: 0.0, count: max(0, 128 * 128 - chroma.count))
      reshapedChroma = stride(from: 0, to: 128 * 128, by: 128).map {
        Array(padded[$0 ..< $0 + 128])
      }
    }
    
    // Model 입력 변환
    guard let input = chromaToCVPixelBuffer(chroma: reshapedChroma),
          let prediction = try? model?.prediction(input_1: input) else {
      return nil
    }
    
    // ['A', 'B7', 'C', 'E', 'G', 'Silence']
    Logger.d("prediction : \(prediction.Identity)")
    let results = convertMLMultiArrayToSwiftArray(prediction.Identity)
    if let maxIndex = results.firstIndex(of: results.max() ?? 0.0) {
      let confidence = results[maxIndex]
      if confidence < minConfidenceThreshold { return nil }
      if output.count != results.count {
        Logger.e("GuitarChordClassifier의 결과물과 output 배열의 크기가 다릅니다.")
        return nil
      }
      return (output[maxIndex], confidence, input)
    } else {
      print("배열이 비어있거나 값을 찾을 수 없습니다.")
    }
    return nil
  }
  
  private func convertMLMultiArrayToSwiftArray(_ multiArray: MLMultiArray) -> [Float] {
    guard multiArray.dataType == .float32 || multiArray.dataType == .double else {
      return []
    }
    
    var swiftArray: [Float] = []
    for i in 0..<multiArray.count {
      swiftArray.append(multiArray[i].floatValue)
    }
    return swiftArray
  }
  
  private func chromaToCVPixelBuffer(chroma: [[Float]]) -> CVPixelBuffer? {
    guard chroma.count == 128 && chroma.allSatisfy({ $0.count == 128 }) else {
      print("Error: Chroma input must be 128x128.")
      return nil
    }
    
    let width = 128
    let height = 128
    let attrs = [
      kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
      kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
    ] as CFDictionary
    var pixelBuffer: CVPixelBuffer?
    
    // CVPixelBuffer 생성 (BGRA 포맷)
    let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                     kCVPixelFormatType_32BGRA,
                                     attrs, &pixelBuffer)
    guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
      print("Error: Failed to create CVPixelBuffer. Status: \(status)")
      return nil
    }
    
    CVPixelBufferLockBaseAddress(buffer, [])
    guard let baseAddress = CVPixelBufferGetBaseAddress(buffer) else {
      CVPixelBufferUnlockBaseAddress(buffer, [])
      print("Error: Failed to get base address of CVPixelBuffer.")
      return nil
    }
    
    let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
    let bufferPointer = baseAddress.assumingMemoryBound(to: UInt8.self)
    
    // Chroma 값의 최소/최대값 찾기
    let flatChroma = chroma.flatMap { $0 }
    guard let minVal = flatChroma.min(), let maxVal = flatChroma.max() else {
      CVPixelBufferUnlockBaseAddress(buffer, [])
      print("Error: Could not find min/max values in chroma data.")
      return nil
    }
    
    // 모든 값이 동일할 경우 (minVal == maxVal) 0으로 나누는 것을 방지
    let valueRange = maxVal - minVal
    let needsNormalization = valueRange > 0.00001 // 아주 작은 오차 허용
    
    for y in 0..<height {
      for x in 0..<width {
        let chromaValue = chroma[y][x]
        var norm: Float
        if needsNormalization {
          norm = (chromaValue - minVal) / valueRange
        } else {
          norm = 0.0
        }
        // Grayscale mapping: higher chroma = darker (gray_r style)
        let gray = UInt8((1.0 - norm) * 255.0)
        let pixelOffset = y * bytesPerRow + x * 4
        bufferPointer[pixelOffset + 0] = gray  // Blue
        bufferPointer[pixelOffset + 1] = gray  // Green
        bufferPointer[pixelOffset + 2] = gray  // Red
        bufferPointer[pixelOffset + 3] = 255   // Alpha
      }
    }
    
    CVPixelBufferUnlockBaseAddress(buffer, [])
    return buffer
  }
}
