//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevConfigView: View {
  var body: some View {
    BaseView(
      create: { DevConfigViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Config")

        Form {
          // MARK: TTS Speed
          Section(header: Text("TTS Speed")) {
            Text("TTS 재생 속도 : \(state.ttsSpeed.value.formatted(2))")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateTtsSpeed(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateTtsSpeed(isSpeedUp: true) })
          }

          // MARK: Full Track Play Speed
          Section(header: Text("Full Song Play Speed")) {
            Text("곡 재생 속도 : x\(state.fullTrackPlaySpeed.value.formatted(2))")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateFullTrackPlaySpeed(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateFullTrackPlaySpeed(isSpeedUp: true) })
          }

          // MARK: Chord Throttle
          Section(header: Text("Chord Throttle Interval")) {
            Text("Chord 인식 간격 : \(state.chordThrottleInterval.formatted(2))s")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateChordThrottleInterval(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateChordThrottleInterval(isSpeedUp: true) })
          }

          // MARK: Note Throttle
          Section(header: Text("Note Throttle Interval")) {
            Text("Note 인식 간격 : \(state.noteThrottleInterval.formatted(2))s")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateNoteThrottleInterval(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateNoteThrottleInterval(isSpeedUp: true) })
          }
          
          // MARK:
          Section(header: Text("Chord Classification")) {
            Text("Note 인식 간격")
            Picker(
              selection: Binding(
                get: { state.chordClassificationType },
                set: {
                  viewModel.updateChordClassificationType(type: $0)
                }
              ),
              label: Text("코드 인식 방법")
            ) {
              ForEach(ChordClassificationType.allCases, id: \.self) { type in
                Text(type.rawValue)
                  .tag(type)
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    DevConfigView()
  }
}
