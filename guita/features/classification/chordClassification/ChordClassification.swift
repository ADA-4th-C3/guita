//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation
import Foundation

final class ChordClassification {
  private let chromaExtractor = ChromaExtractor()

  // MARK: - 버퍼 입력 감지
  func run(
    buffer: AVAudioPCMBuffer,
    windowSize: Int,
    activeChords: [Chord] = Chord.allCases,
    minConfidenceThreshold: Float = 0.5
  ) -> (chord: Chord, confidence: Float)? {
    guard let data = buffer.floatChannelData?[0] else { return nil }
    let frameLength = Int(buffer.frameLength)
    let audioArray = Array(UnsafeBufferPointer(start: data, count: frameLength))
    let chroma = chromaExtractor.extract(
      from: audioArray,
      sampleRate: Float(buffer.format.sampleRate),
      windowSize: windowSize,
      hopSize: Int(windowSize / 2)
    )
    let chordResult = matchChord(chromaFeatures: chroma)
    let (chord, confidence) = (chordResult.chord, chordResult.confidence)
    if !activeChords.contains(chord) { return nil }
    if confidence < minConfidenceThreshold { return nil }
    return (chord, confidence)
  }

  // MARK: - 정규화
  private func normalizeVector(_ v: [Float]) -> [Float] {
    let norm = sqrt(v.map { $0 * $0 }.reduce(0, +))
    return norm > 0 ? v.map { $0 / norm } : v
  }

  // MARK: - 내적
  private func dotProduct(_ a: [Float], _ b: [Float]) -> Float {
    guard a.count == b.count else { return 0 }
    var res: Float = 0
    vDSP_dotpr(a, 1, b, 1, &res, vDSP_Length(a.count))
    return res
  }

  // MARK: - 매칭
  private func matchChord(chromaFeatures: [Float]) -> ChordResult {
    var matches: [(Chord, Float)] = []
    for chord in Chord.allCases {
      let tpl = chord.chroma
      let ntpl = normalizeVector(tpl)
      let cosSim = dotProduct(chromaFeatures, ntpl)
      let dist = zip(chromaFeatures, ntpl).map { pow($0 - $1, 2) }.reduce(0, +)
      let euclid = max(0, 1 - sqrt(dist) / Float(sqrt(2)))
      let conf = cosSim * 0.7 + euclid * 0.3
      matches.append((chord, conf))
    }
    matches.sort { $0.1 > $1.1 }
    let best = matches.first ?? (.C, 0)
    let chord = best.1 > 0.3 ? best.0 : .C
    let all = matches.map { (chord: $0.0, confidence: $0.1) }
    return ChordResult(chord: chord, confidence: best.1, allMatches: all)
  }
}
