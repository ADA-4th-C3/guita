//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SongProgressBar: View {
  let currentTime: Double
  let totalDuration: Double

  private var progress: Double {
    guard totalDuration > 0 else { return 0 }
    return min(currentTime / totalDuration, 1.0)
  }

  private func formatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }

  var body: some View {
    VStack(spacing: 12) {
      // Progress bar
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background track
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 8)

          // Progress fill
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.primary)
            .frame(width: geometry.size.width * progress, height: 8)
            .animation(.linear(duration: 0.1), value: progress)
        }
      }
      .frame(height: 8)

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
    .accessibilityElement(children: .combine)
    .accessibilityLabel("재생 진행률: \(Int(progress * 100))퍼센트, \(formatTime(currentTime)) / \(formatTime(totalDuration))")
  }
}

#Preview {
  VStack(spacing: 20) {
    SongProgressBar(currentTime: 45, totalDuration: 180)
    SongProgressBar(currentTime: 120, totalDuration: 180)
    SongProgressBar(currentTime: 0, totalDuration: 180)
  }
  .padding()
}
