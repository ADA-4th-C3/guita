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
          case .curriculum: CurriculumView()
          case .dev: DevView()
          case .pitchClassification: PitchClassificationView()
          case .codeClassification: CodeClassificationView()
          case .voiceControl: VoiceControlView()
            
            // 새로 추가되는 케이스들
          case .guitarLearning: GuitarLearningView()
          case .codeLearningList: CodeLearningListView()
          case .techniqueList: Text("주법 학습") // 구현 예정
          case .sectionPractice: SectionPracticeView()
          case .fullSongPractice: FullSongPracticeView()
          case .codeDetail(let codeType): CodeDetailView(codeType: codeType)
          case .codeHelp(let codeType): Text("\(codeType.rawValue) 도움말") // 구현 예정
          case .techniqueHelp: Text("주법 도움말") // 구현 예정
          case .sectionPracticeHelp: Text("곡 구간 학습 도움말") // 구현 예정
          case .fullSongPracticeHelp: Text("곡 전체 학습 도움말") // 구현 예정
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
