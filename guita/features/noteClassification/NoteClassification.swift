//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

struct NoteClassification {
  private func getClosestNoteName(for frequency: Double) -> Note? {
    var minDiff = Double.infinity
    var closestNote: Note? = nil
    for note in Note.allCases {
      let diff = abs(note.frequency - frequency)
      if diff < minDiff {
        minDiff = diff
        closestNote = note
      }
    }
    return closestNote
  }

  func run(
    buffer: AVAudioPCMBuffer,
    sampleRate: Double,
    windowSize: Int,
    minVolumeThreshold: Double = 0.01
  ) -> Note? {
    // Audio data in buffer
    guard let channelData = buffer.floatChannelData?[0] else { return nil }
    let frameLength = Int(buffer.frameLength)

    // RMS
    var sumSquares: Double = 0
    for i in 0 ..< frameLength {
      let sample = Double(channelData[i])
      sumSquares += sample * sample
    }
    let rms = sqrt(sumSquares / Double(frameLength))
    if rms < minVolumeThreshold {
      return nil
    }

    var samples = [Complex]()
    for i in 0 ..< windowSize {
      // Hamming Window
      // - FFT는 입력 신호가 주기적이고 무한하다고 가정하지만 실제 오디오 신호는 짧은 구간만 자른 것(프레임)이라 양 끝이 갑자기 끊키면서 스펙트럼 누설(leakage)이라는 왜곡을 유발함.
      // - 신호의 양 끝을 부드럽게 0에 가깝게 만드는 창(window) 함수로   FFT에 부드러운 경계 조건을 만들어줌.
      let window = 0.5 * (1 - cos(2 * Double.pi * Double(i) / Double(windowSize - 1)))

      // 복소수로 표현 (허수부 0으로 구현)
      // FFT(푸리에 변환)는 원래 복소수 정현파의 합으로 신호를 분해하는 알고리즘이라
      // 입력 신호가 실수이더라도 계산상 복소수 공간에서 주파수 분석을 해야함.
      samples.append(Complex(Double(channelData[i]) * window, 0))
    }

    // Ensure samples count is a power of two
    let N = windowSize

    if samples.count < N { return nil }

    let fftInput = Array(samples[0 ..< N])
    // FFT 결과
    // - windowSize 크기의 배열
    // - Frequency Resolution(5.86Hz) = Sample Rage(48000) / windowSize(8192)
    // - 0번째 index : 0 ~ 5.86Hz 사이 주파수 성분의 크기(magnitude)와 위상(phase)을 표현
    let fftResult = FestFourierTransform().run(fftInput)

    // 크기(Magnitude, 신호가 그 주파수에서 얼마나 강한지 나타냄) = 루트(실수부^2 + 허수부^2)
    // 위상(Phase, 그 주파수 성분의 시간적 위치나 진행 상태) = arctan(허수부 / 실수부)
    let magnitudes = fftResult.map { sqrt($0.real * $0.real + $0.imag * $0.imag) }

    // Nyquist frequency (24000Hz) = sampling rate(48000Hz) / 2
    // - 샘플링 주파수의 절반 이상인 주파수 성분은 올바르게 표현할 수 없습니다.
    // - 신호가 왜곡되어 낮은 주파수로 착각되는 현상(aliasing)이 발생하기 때문.
    // - FFT의 결과는 복소수 배열인데, 이 배열은 대칭 구조를 가지기 때문.
    // - 0~N/2까지는 양의 주파수 성분, 나머지는 음의 주파수 성분을 복소수 켤레로 나타냄.
    // - 실제로는 인덱스 0 ~ N/2까지만 유효한 주파수 정보를 가지고 있고, 나머지는 대칭(복소공간의 복사본)이므로 버림.
    let halfN = N / 2
    let magnitudesHalf = Array(magnitudes[0 ..< halfN])

    // HPS (Harmonic Product Spectrum)
    // - 소리에는 기본 주파수와 배수인 배음(harmonics)가 함께 존재하는데, 여기에서 기본 주파수 피치를 검출하는 기법(E2를 연주했지만 E3가 잡히는 FFT 문제 해결)
    // - 원래는 다운샘플링을 해서 배음이 겹쳐지면서 기본음이 강화되는 방식인데, 여기에서 곱 연산으로 기본 주파수를 강화하는 방식으로 찾음.
    // - 다른 인덱스는 곱했을 때 더 작아져서 상대적으로 기본 주파수 후보 위치가 더 명확해짐.
    // - E3를 연주해도 E2가 미세하게 포함될 가능성은 있지만, 보통 기본 주파수보다 낮은 주파수는 약하고 명확하지 않음.
    var hps = magnitudesHalf

    // 4개 배음까지 고려
    let harmonics = 4
    for h in 2 ... harmonics {
      for i in 0 ..< (halfN / h) {
        // E2 = E2 * E3 * E4 * E5
        // E3 = E3 * E4 * E5 * E6
        hps[i] *= magnitudes[i * h]
      }
    }

    // E2가 82.41Hz이므로 70Hz 이상에서만 피크 찾기
    let minIndex = Int(70.0 * Double(N) / sampleRate)
    let searchRange = minIndex ..< (halfN / harmonics)

    if let maxIndex = searchRange.max(by: { hps[$0] < hps[$1] }) {
      let frequency = Double(maxIndex) * sampleRate / Double(N)
      guard let note = getClosestNoteName(for: frequency) else { return nil }
      Logger.d("Frequency: \(frequency) Hz, Note: \(note)")
      return note
    } else {
      return nil
    }
  }
}
