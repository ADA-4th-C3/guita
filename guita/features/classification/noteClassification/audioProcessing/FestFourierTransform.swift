//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation

final class FestFourierTransform {
  func runForStudy(_ input: [Complex]) -> [Complex] {
    let n = input.count
    if n == 1 {
      return input
    }
    if n & (n - 1) != 0 {
      fatalError("Input size must be a power of 2")
    }
    let even = run((0 ..< n / 2).map { input[2 * $0] })
    let odd = run((0 ..< n / 2).map { input[2 * $0 + 1] })

    var output = Array(repeating: Complex(0, 0), count: n)
    for k in 0 ..< n / 2 {
      let twiddle = Complex(cos(-2 * Double.pi * Double(k) / Double(n)),
                            sin(-2 * Double.pi * Double(k) / Double(n)))
      output[k] = even[k] + twiddle * odd[k]
      output[k + n / 2] = even[k] - twiddle * odd[k]
    }
    return output
  }

  func run(_ input: [Complex]) -> [Complex] {
    let n = input.count
    let log2n = vDSP_Length(log2(Float(n)))
    guard let setup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
      fatalError("Failed to create FFT setup.")
    }
    defer { vDSP_destroy_fftsetup(setup) }

    var real = input.map { Float($0.real) }
    var imag = input.map { Float($0.imag) }
    real.withUnsafeMutableBufferPointer { rptr in
      imag.withUnsafeMutableBufferPointer { iptr in
        var c = DSPSplitComplex(realp: rptr.baseAddress!, imagp: iptr.baseAddress!)
        vDSP_fft_zip(setup, &c, 1, log2n, FFTDirection(FFT_FORWARD))
      }
    }

    var output = [Complex]()
    for i in 0 ..< n {
      output.append(Complex(Double(real[i]), Double(imag[i])))
    }

    return output
  }
}
