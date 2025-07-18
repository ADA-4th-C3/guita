//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import Foundation

final class ChromaExtractor {
  func extract(
    from audioData: [Float],
    sampleRate: Float,
    windowSize: Int,
    hopSize: Int
  ) -> [Float] {
    let frames = max(1, (audioData.count - windowSize) / hopSize + 1)
    var sumChroma = Array(repeating: Float(0), count: 12)
    var valid = 0

    for i in 0 ..< frames {
      let start = i * hopSize
      let end = min(start + windowSize, audioData.count)
      var frame = Array(audioData[start ..< end])
      if frame.count < windowSize {
        frame += Array(repeating: 0, count: windowSize - frame.count)
      }
      let spec = performFFT(frame)
      let chroma = spectrumToChroma(spec, sampleRate: sampleRate)
      let energy = chroma.reduce(0, +)
      if energy > 0.01 {
        for j in 0 ..< 12 {
          sumChroma[j] += chroma[j]
        }
        valid += 1
      }
    }

    if valid > 0 {
      for i in 0 ..< 12 {
        sumChroma[i] /= Float(valid)
      }
    }

    for i in 0 ..< 12 {
      sumChroma[i] = log(1 + sumChroma[i] * 10)
    }

    return normalizeVector(sumChroma)
  }

  private func spectrumToChroma(_ spectrum: [Float], sampleRate: Float) -> [Float] {
    var chroma = Array(repeating: Float(0), count: 12)
    let binCount = spectrum.count
    let nyquist = sampleRate / 2
    let guitarFreqs: [Float] = [82.41, 110, 146.83, 196, 246.94, 329.63]

    for bin in 1 ..< binCount {
      let freq = Float(bin) * nyquist / Float(binCount)
      guard freq >= 80, freq <= 4000 else { continue }
      let note = 12 * log2(freq / 440) + 69
      var idx = Int(note.rounded()) % 12
      if idx < 0 { idx += 12 }

      var weight: Float =
        (freq >= 82 && freq <= 1320) ? 2 : (freq >= 164 && freq <= 2640) ? 1.5 : 1.2
      for gf in guitarFreqs where abs(freq - gf) < 5 {
        weight *= 1.5
      }

      chroma[idx] += spectrum[bin] * weight
    }

    if let m = chroma.max(), m > 0 {
      for i in 0 ..< 12 {
        chroma[i] /= m
      }
    }

    return chroma
  }

  private func normalizeVector(_ v: [Float]) -> [Float] {
    let norm = sqrt(v.map { $0 * $0 }.reduce(0, +))
    return norm > 0 ? v.map { $0 / norm } : v
  }

  private func performFFT(_ frame: [Float]) -> [Float] {
    let n = frame.count
    let log2n = vDSP_Length(log2(Float(n)))
    guard let setup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
    else { return Array(repeating: 0, count: n / 2) }
    defer { vDSP_destroy_fftsetup(setup) }

    var real = frame
    var imag = Array(repeating: Float(0), count: n)
    real.withUnsafeMutableBufferPointer { rptr in
      imag.withUnsafeMutableBufferPointer { iptr in
        var c = DSPSplitComplex(realp: rptr.baseAddress!, imagp: iptr.baseAddress!)
        vDSP_fft_zip(setup, &c, 1, log2n, FFTDirection(FFT_FORWARD))
      }
    }

    var mags = Array(repeating: Float(0), count: n / 2)
    real.withUnsafeMutableBufferPointer { rptr in
      imag.withUnsafeMutableBufferPointer { iptr in
        var c = DSPSplitComplex(realp: rptr.baseAddress!, imagp: iptr.baseAddress!)
        vDSP_zvmags(&c, 1, &mags, 1, vDSP_Length(n / 2))
      }
    }

    return mags
  }
}
