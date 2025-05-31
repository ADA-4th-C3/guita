//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonDetailView: View {
  var body: some View {
    
    BaseView(
      create: { LessonDetailViewModel() }
    ) { viewModel, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "초급")
        Spacer()
    
        }
      }
    }
  }


#Preview {
  BasePreview {
    CurriculumView()
  }
}

