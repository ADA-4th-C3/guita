//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonView: View {
  let chord: Chord
  var body: some View {
    BaseView(
      create: { ChordLessonViewModel(chord) }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.onPermissionGranted()
          }
        }
      ) {
        VStack(spacing: 0) {
          // MARK: Toolbar
          Toolbar(title: "\(state.chord) 코드")

          // MARK: Index
          Text("\(state.index + 1)/\(state.totalStep) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
          Spacer()

          // MARK: Step description
          Text("\(state.step.getDescription(state.chord, index: state.index))")
            .fontKoddi(26, color: .light)
            .lineSpacing(1.45)
            .multilineTextAlignment(.center)
          
          Spacer()

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", color: .light, size: 95, isSystemImage: false) {
              viewModel.goPrevious()
            }
            IconButton("play", size: 95, isSystemImage: false) {
              viewModel.play()
            }
            IconButton("chevron-right", color: .light, size: 95, isSystemImage: false) {
              viewModel.goNext()
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordLessonView(chord: .A)
  }
}
