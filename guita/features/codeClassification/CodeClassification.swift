//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation
import Foundation

final class CodeClassification {
  // MARK: - 템플릿 및 노트 이름
  private let codeTemplates: [String: [Float]] = [
    "C":    [1.0, 0.0, 0.2, 0.0, 0.8, 0.0, 0.1, 0.9, 0.0, 0.0, 0.1, 0.0],
    "Dm":   [0.0, 0.1, 0.9, 0.0, 0.0, 0.8, 0.0, 0.0, 0.2, 1.0, 0.0, 0.0],
    "Em":   [0.0, 0.0, 0.1, 0.0, 0.9, 0.0, 0.0, 0.8, 0.0, 0.0, 0.2, 1.0],
    "F":    [0.8, 0.0, 0.0, 0.1, 0.0, 1.0, 0.0, 0.0, 0.2, 0.9, 0.0, 0.0],
    "G":    [0.2, 0.0, 0.8, 0.0, 0.0, 0.1, 0.0, 1.0, 0.0, 0.0, 0.3, 0.9],
    "Am":   [0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.1, 0.0, 0.8, 1.0, 0.0, 0.0],
    "Bdim": [0.0, 0.0, 0.8, 0.0, 0.0, 0.9, 0.0, 0.0, 0.1, 0.0, 0.2, 1.0],
    "A":    [0.0, 0.1, 0.0, 0.2, 0.8, 0.0, 0.0, 0.1, 0.0, 1.0, 0.0, 0.0],
    "D":    [0.0, 0.0, 1.0, 0.0, 0.1, 0.0, 0.8, 0.0, 0.0, 0.9, 0.0, 0.0],
    "E":    [0.0, 0.0, 0.0, 0.1, 1.0, 0.0, 0.0, 0.2, 0.8, 0.0, 0.0, 0.9],
    "B7":   [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.2, 0.0, 1.0]
  ]
  private let noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
  
  struct CodeResult {
    let code: String
    let confidence: Float
    let allMatches: [(code: String, confidence: Float)]
  }
  
  // MARK: - 버퍼 입력 감지
  func detectCode(buffer: AVAudioPCMBuffer, windowSize: Int) -> CodeResult? {
    guard let data = buffer.floatChannelData?[0] else { return nil }
    let frameLength = Int(buffer.frameLength)
    let audioArray = Array(UnsafeBufferPointer(start: data, count: frameLength))
    let chroma = extractChromaFeatures(
      from: audioArray,
      sampleRate: Float(buffer.format.sampleRate),
      windowSize: windowSize,
      hopSize: Int(windowSize/2) // 4로 나누면 75% 오버렙, 2로 나누면 50% 오버렙
    )
    return matchCode(chromaFeatures: chroma)
  }
  
  // MARK: - 크로마 특성 추출
  private func extractChromaFeatures(
    from audioData: [Float],
    sampleRate: Float,
    windowSize: Int,
    hopSize: Int
  ) -> [Float] {
    let frames = max(1, (audioData.count - windowSize) / hopSize + 1)
    var sumChroma = Array(repeating: Float(0), count: 12)
    var valid = 0
    
    for i in 0..<frames {
      let start = i * hopSize
      let end = min(start + windowSize, audioData.count)
      var frame = Array(audioData[start..<end])
      if frame.count < windowSize {
        frame += Array(repeating: 0, count: windowSize - frame.count)
      }
      let spec = performFFT(frame)
      let chroma = spectrumToChroma(spec, sampleRate: sampleRate)
      let energy = chroma.reduce(0, +)
      if energy > 0.01 {
        for j in 0..<12 { sumChroma[j] += chroma[j] }
        valid += 1
      }
    }
    if valid > 0 {
      for i in 0..<12 { sumChroma[i] /= Float(valid) }
    }
    // 로그 스케일
    for i in 0..<12 { sumChroma[i] = log(1 + sumChroma[i] * 10) }
    return normalizeVector(sumChroma)
  }
  
  // MARK: - FFT
  private func performFFT(_ frame: [Float]) -> [Float] {
    let n = frame.count
    let log2n = vDSP_Length(log2(Float(n)))
    guard let setup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
    else { return Array(repeating: 0, count: n/2) }
    defer { vDSP_destroy_fftsetup(setup) }
    
    var real = frame
    var imag = Array(repeating: Float(0), count: n)
    real.withUnsafeMutableBufferPointer { rptr in
      imag.withUnsafeMutableBufferPointer { iptr in
        var c = DSPSplitComplex(realp: rptr.baseAddress!, imagp: iptr.baseAddress!)
        vDSP_fft_zip(setup, &c, 1, log2n, FFTDirection(FFT_FORWARD))
      }
    }
    var mags = Array(repeating: Float(0), count: n/2)
    real.withUnsafeMutableBufferPointer { rptr in
      imag.withUnsafeMutableBufferPointer { iptr in
        var c = DSPSplitComplex(realp: rptr.baseAddress!, imagp: iptr.baseAddress!)
        vDSP_zvmags(&c, 1, &mags, 1, vDSP_Length(n/2))
      }
    }
    return mags
  }
  
  // MARK: - 스펙트럼→크로마
  private func spectrumToChroma(_ spectrum: [Float], sampleRate: Float) -> [Float] {
    var chroma = Array(repeating: Float(0), count: 12)
    let binCount = spectrum.count
    let nyquist = sampleRate / 2
    let guitarFreqs: [Float] = [82.41,110,146.83,196,246.94,329.63]
    
    for bin in 1..<binCount {
      let freq = Float(bin) * nyquist / Float(binCount)
      guard freq >= 80, freq <= 4000 else { continue }
      let note = 12 * log2(freq/440) + 69
      var idx = Int(note.rounded()) % 12
      if idx < 0 { idx += 12 }
      var weight: Float =
      (freq>=82 && freq<=1320) ? 2 : (freq>=164&&freq<=2640) ? 1.5 : 1.2
      for gf in guitarFreqs where abs(freq-gf)<5 { weight *= 1.5 }
      chroma[idx] += spectrum[bin] * weight
    }
    if let m = chroma.max(), m>0 { for i in 0..<12 { chroma[i]/=m } }
    return chroma
  }
  
  // MARK: - 정규화
  private func normalizeVector(_ v: [Float]) -> [Float] {
    let norm = sqrt(v.map{ $0*$0 }.reduce(0, +))
    return norm>0 ? v.map{ $0 / norm } : v
  }
  
  // MARK: - 내적
  private func dotProduct(_ a:[Float], _ b:[Float]) -> Float {
    guard a.count==b.count else { return 0 }
    var res: Float = 0
    vDSP_dotpr(a,1,b,1,&res,vDSP_Length(a.count))
    return res
  }
  
  // MARK: - 매칭
  private func matchCode(chromaFeatures: [Float]) -> CodeResult {
    var matches: [(String,Float)] = []
    for (name, tpl) in codeTemplates {
      let ntpl = normalizeVector(tpl)
      let cosSim = dotProduct(chromaFeatures, ntpl)
      let dist = zip(chromaFeatures,ntpl).map{ pow($0-$1,2) }.reduce(0,+)
      let euclid = max(0,1-sqrt(dist)/Float(sqrt(2)))
      let conf = cosSim*0.7 + euclid*0.3
      matches.append((name,conf))
    }
    matches.sort{ $0.1>$1.1 }
    let best = matches.first ?? ("Unknown",0)
    let code = best.1>0.3 ? best.0 : "Unknown"
    let all = matches.map{ (code:$0.0,confidence:$0.1) }
    return CodeResult(code: code, confidence: best.1, allMatches: all)
  }
  
  // Overload된 매칭
  private func matchCode(chromaFeatures:[Float],
                         templates: [String:[Float]]) -> CodeResult {
    var list: [(String,Float)] = []
    for (name,tpl) in templates {
      let nt = normalizeVector(tpl)
      let cs = dotProduct(chromaFeatures, nt)
      let d = zip(chromaFeatures,nt).map{ pow($0-$1,2) }.reduce(0,+)
      let eu = max(0,1-sqrt(d)/Float(sqrt(2)))
      list.append((name, cs*0.7+eu*0.3))
    }
    list.sort{ $0.1>$1.1 }
    let b = list.first ?? ("Unknown",0)
    let ch = b.1>0.3 ? b.0 : "Unknown"
    let all = list.map{ (code:$0.0,confidence:$0.1) }
    return CodeResult(code:ch, confidence:b.1, allMatches:all)
  }
}
