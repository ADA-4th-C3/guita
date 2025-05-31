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
            // 기본 화면들
          case .dev: DevView()
          case .pitchClassification: PitchClassificationView()
          case .codeClassification: CodeClassificationView()
          case .voiceControl: VoiceControlView()
            
            // 기타 학습 관련 화면들
          case .guitarLearning: GuitarLearningView()        // 기타 학습 메인
          case .learningOptions(let song): LearningOptionsView(song: song)  // 학습 옵션 선택
            
            // 코드 학습
          case .chordLearningList: ChordLearningListView()  // 코드 학습 리스트
          case .codeDetail(let song, let chord): CodeDetailView(song: song, chord: chord)
          case .codeHelp(let chord): CodeHelpView(chord: chord)
            
            // 주법 학습
          case .techniqueDetail(let song): TechniqueDetailView(song: song)
          case .techniqueList: TechniqueListView()
          case .techniqueHelp: TechniqueHelpView()
            
            // 구간 학습
          case .sectionPractice(let song): SectionPracticeView(song: song)
          case .sectionPracticeHelp: SectionPracticeHelpView()
            
            // 곡 전체 학습
          case .fullSongPractice(let song): FullSongPracticeView(song: song)
          case .fullSongPracticeHelp: FullSongPracticeHelpView()
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
