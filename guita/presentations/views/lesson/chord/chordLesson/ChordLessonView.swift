//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonView: View {
  @EnvironmentObject var router: Router
  let chord: Chord
  let chords: [Chord]

  var body: some View {
    BaseView(
      create: { ChordLessonViewModel(router, chord, chords) }
    ) { viewModel, state in
//      PermissionView(
//        permissionListener: { isGranted in
//          if isGranted {
//            viewModel.onPermissionGranted()
//          }
//        }
//      )
//      {
        VStack(spacing: 0) {
          // MARK: Toolbar
          Toolbar(
            title: String(
              format: NSLocalizedString("%@ 코드", comment: ""),
              "\(state.chord.rawValue)"
            ),
            accessibilityHint: String(
              format: NSLocalizedString(
                state.isPermissionGranted
                  ? "ChordLessonView.Accessibility.Description"
                  : "ChordLessonView.Accessibility.Description.NoPermission",
                comment: ""
              ),
              "\(state.chord.rawValue)"
            ),
            firstTrailing: {
              IconButton("info") {
                router.push(.chordLessonGuide)
              }.accessibilityAddTraits(.isButton)
                .accessibilityLabel("사용법 도움말")
            },
            secondTrailing: {
              IconButton("gearshape", isSystemImage: true) {
                router.push(.setting)
              }.accessibilityAddTraits(.isButton)
              .accessibilityHint("설정 화면으로 이동")
            }
            
          )

          // MARK: Index
          HStack {
            Spacer()
            Text("\(state.index + 1)/\(state.totalStep)")
              .fontKoddi(22, color: .darkGrey)
              .padding(.top, 16)
              .padding(.trailing, 10)
              .accessibilityHidden(true)
          }
          
          
          ChordStringGuideView(chord: state.chord)
            

          // MARK: Step description
          Text(state.description)
            .fontKoddi(26, color: .light, weight: .bold)
            .lineSpacing(1.45)
            .padding(.top, 20)
            .multilineTextAlignment(.center)
            .accessibilityHidden(true)
            

          Spacer()

          // MARK: Controllers
          BottomController(
            previousDisabled: state.step == .introduction,
            isIntroduction: state.step == .introduction,
            description: state.description,
            nextChordAccessibilityHint: state.nextChordAccessibilityHint,
            goPrevious: {viewModel.goPrevious()},
            play: {viewModel.play()},
            goNext: {viewModel.goNext()}
          )
          
        }
      }
    }
  }
//}

#Preview {
  BasePreview {
    ChordLessonView(chord: .A, chords: [.A, .E, .B7])
  }
}
