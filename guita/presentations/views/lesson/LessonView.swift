//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonView: View {
  let songInfo: SongInfo
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { LessonViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        let title = songInfo.title
        let chords = songInfo.chords.map { $0.description }.joined(separator: ", ")
        Toolbar(
          title: songInfo.level,
          accessibilityLabel: String(
            format: NSLocalizedString("Lesson.Accessibility.Label", comment: ""),
            "[\(songInfo.level)] \(title)"
          ),
          accessibilityHint: String(
            format: NSLocalizedString("Lesson.Accessibility.Description", comment: ""),
            title,
            chords
          )
        )

        Spacer()

        // MARK: SongTitle & Code
        VStack {
          VStack {
            Text(songInfo.title)
              .fontKoddi(26, color: .light, weight: .bold)
              .accessibilityHidden(true)
              .padding(.bottom, 6)

            Text(songInfo.chords.map { "\($0.rawValue)" }.joined(separator: ", "))
              .fontKoddi(18, color: .darkGrey, weight: .regular)
              .accessibilityHidden(true)
          }
          .frame(maxWidth: .infinity, maxHeight: 220)

          // MARK: Learning Buttons
          GeometryReader { geometry in
            let boxWidth = geometry.size.width
            let boxHeight = geometry.size.height / 4

            LazyVStack(spacing: 0) {
              ListDivider()

              Button(action: {
                router.push(.chord(songInfo: songInfo))
              }) {
                Text("코드 학습")
                  .fontKoddi(26, color: .light, weight: .bold)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("코드 학습하기")
              }
              ListDivider()

              Button(action: {
                router.push(.techniqueLesson) // 임시로 라우팅 해둠
              }) {
                Text("주법 학습")
                  .fontKoddi(26, color: .light, weight: .bold)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("주법 학습하기")
              }
              ListDivider()

              Button(action: {
                router.push(.sectionLesson)
              }) {
                Text("곡 구간 학습")
                  .fontKoddi(26, color: .light, weight: .bold)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("곡 구간 학습하기")
              }
              ListDivider()

              Button(action: {
                router.push(.fullLesson(songInfo: songInfo))
              }) {
                Text("곡 전체 학습")
                  .fontKoddi(26, color: .light, weight: .bold)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("곡 전체 학습하기")
              }
              ListDivider()

              Rectangle()
                .fill(.black)
                .frame(width: boxWidth, height: boxHeight)
                .accessibilityHidden(true)
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    LessonView(songInfo: SongInfo.curriculum.first!)
  }
}
