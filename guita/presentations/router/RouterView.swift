//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct RouterView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    NavigationStack(
      path: Binding(
        get: { router.state.subPages },
        set: router.setSubPages
      )
    ) {
      Layout {
        // MARK: Root page
        ZStack {
          switch router.state.rootPage {
          case .splash: SplashView()
          case .home: HomeView()
          }
        }

        // MARK: Sub page
        .navigationDestination(for: SubPage.self) { subPage in
          switch subPage {
          // MARK: User
          case .setting: SettingView()
          case .curriculum: CurriculumView()
          case let .lesson(songInfo): LessonView(songInfo: songInfo)
          case let .chord(songInfo): ChordView(songInfo: songInfo)
          case let .chordLesson(chord, chords): ChordLessonView(chord: chord, chords: chords)
          case .chordLessonGuide: ChordLessonGuideView()
          case .techniqueLesson: TechniqueLessonView()
          case .techniqueLessonGuide: TechniqueLessonGuideView()
          case .sectionLesson: SectionLessonView()
          case .sectionLessonGuide: SectionLessonGuideView()
          case let .fullLesson(songInfo): FullLessonView(songInfo: songInfo)
          case .fullLessonGuide: FullLessonGuideView()
          // MARK: Dev
          case .dev: DevView()
          case .devConfig: DevConfigView()
          case .devPermission: DevPermissionView()
          case .devVoiceCommand: DevVoiceCommandView()
          case .devTextToSpeech: DevTextToSpeechView()
          case .devNoteClassification: DevNoteClassificationView()
          case .devCodeClassificationWithSimilarity: DevChordClassificationWithSimilarityView()
          case .devChordClassificationWithRegression: DevChordClassificationWithRegressionView()
          }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
      }
    }
  }
}

#Preview {
  BasePreview {
    RouterView()
  }
}
