//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonView: View {
  let songInfo: SongInfo
  @EnvironmentObject var router: Router
  @State private var selected: String? = nil

  var body: some View {
    BaseView(
      create: { LessonViewModel() }
    ) { _, _ in
      ZStack {
        VStack {
          // MARK: Toolbar
          let title = songInfo.title
          let chords = songInfo.chords.map { $0.description }.joined(
            separator: ", "
          )
          Toolbar(
            title: songInfo.title,
            accessibilityLabel: String(
              format: NSLocalizedString(
                "Lesson.Accessibility.Label",
                comment: ""
              ),
              "[\(songInfo.title)] \(title)"
            ),
            accessibilityHint: String(
              format: NSLocalizedString(
                "Lesson.Accessibility.Description",
                comment: ""
              ),
              title,
              chords
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

          // MARK: Learning Buttons
          GeometryReader { geometry in
            let boxWidth = geometry.size.width
            let boxHeight = geometry.size.height / 7

            VStack(spacing: 0) {
              ListDivider()

              Button(action: {
                router.push(.chord(songInfo: songInfo))
                selected = "chordLearning"
              }) {
                Text("코드 학습")
                  .fontKoddi(
                    26,
                    color: selected == "chordLearning" ? .black : .light,
                    weight: .bold
                  )
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("코드 학습하기")
              }
              .if(selected == "chordLearning") {
                v in v.background(.accent)
              }

              ListDivider()

              Button(action: {
                router.push(.techniqueLesson)
                selected = "techniqueLearning"
              }) {
                Text("주법 학습")
                  .fontKoddi(
                    26,
                    color: selected == "techniqueLearning" ? .black : .light,
                    weight: .bold
                  )
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("주법 학습하기")
              }
              .if(selected == "techniqueLearning") {
                v in v.background(.accent)
              }
              ListDivider()

              Button(action: {
                router.push(.sectionLesson)
                selected = "songSectionLearning"
              }) {
                Text("곡 구간 학습")
                  .fontKoddi(
                    26,
                    color: selected == "songSectionLearning" ? .black : .light,
                    weight: .bold
                  )
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("곡 구간 학습하기")
              }
              .if(selected == "songSectionLearning") {
                v in v.background(.accent)
              }
              ListDivider()

              Button(action: {
                router.push(.fullLesson(songInfo: songInfo))
                selected = "fullSongLearning"
              }) {
                Text("곡 전체 학습")
                  .fontKoddi(
                    26,
                    color: selected == "fullSongLearning" ? .black : .light,
                    weight: .bold
                  )
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("곡 전체 학습하기")
              }
              .if(selected == "fullSongLearning") {
                v in v.background(.accent)
              }
              ListDivider()
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            selected = ""
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
