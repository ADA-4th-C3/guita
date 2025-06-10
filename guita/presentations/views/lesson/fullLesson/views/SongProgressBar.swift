//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SongProgressBar: View {
  @Binding var currentTime: Double
  let totalDuration: Double
  let onSliderIncrease: () -> Void
  let onSliderDecrease: () -> Void

  private func voiceOverFormatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60

    if minutes == 0 {
      return String(
        format: NSLocalizedString("Time.sec", comment: ""),
        "\(seconds)"
      )
    } else {
      return String(
        format: NSLocalizedString("Time.minute", comment: ""),
        "\(minutes)"
      ) + " " + String(
        format: NSLocalizedString("Time.sec", comment: ""),
        "\(seconds)"
      )
    }
  }

  private func formatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }

  var body: some View {
    VStack(spacing: 12) {
      // Interactive Slider
      Slider(value: $currentTime, in: 0 ... totalDuration)
        .accentColor(.primary)
        .accessibilityValue(
          String(
            format: NSLocalizedString("총 재생 시간", comment: ""),
            "\(voiceOverFormatTime(totalDuration))",
            "\(voiceOverFormatTime(currentTime))"
          )
        )
        .accessibilityAdjustableAction { direction in
          if direction == .increment {
            onSliderIncrease()
          } else {
            onSliderDecrease()
          }
        }

      // Time labels
      HStack {
        Text(formatTime(currentTime))
          .fontKoddi(14, color: .darkGrey, weight: .regular)
        Spacer()
        Text(formatTime(totalDuration))
          .fontKoddi(14, color: .gray, weight: .regular)
      }.accessibilityHidden(true)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var time1: Double = 45
    @State private var time2: Double = 120
    @State private var time3: Double = 0

    var body: some View {
      VStack(spacing: 20) {
        SongProgressBar(currentTime: $time1, totalDuration: 180, onSliderIncrease: {}, onSliderDecrease: {})
      }
      .padding()
    }
  }

  return PreviewWrapper()
}
