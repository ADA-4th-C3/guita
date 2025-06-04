//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SongProgressBar: View {
  @Binding var currentTime: Double
  let totalDuration: Double

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

      // Time labels
      HStack {
        Text(formatTime(currentTime))
          .fontKoddi(14, color: .darkGrey, weight: .regular)
        Spacer()
        Text(formatTime(totalDuration))
          .fontKoddi(14, color: .gray, weight: .regular)
      }
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
        SongProgressBar(currentTime: $time1, totalDuration: 180)
        SongProgressBar(currentTime: $time2, totalDuration: 180)
        SongProgressBar(currentTime: $time3, totalDuration: 180)
      }
      .padding()
    }
  }

  return PreviewWrapper()
}
