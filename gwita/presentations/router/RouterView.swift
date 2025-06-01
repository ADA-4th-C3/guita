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
          case .devPermission: DevPermissionView()
          case .dev: DevView()
          case .noteClassification: NoteClassificationView()
          case .codeClassification: ChordClassificationView()
          case .voiceControl: VoiceControlView()
          case let .lesson(item): LessonDetailView(item: item)
          case .technique: TechniqueView()
          case .config: ConfigView()
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
