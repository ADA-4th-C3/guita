//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct GuideSection: Identifiable {
  let id: UUID
  let title: String
  let content: () -> AnyView

  init(id: UUID = UUID(), title: String, content: @escaping () -> some View) {
    self.id = id
    self.title = title
    self.content = { AnyView(content()) }
  }
}

struct GuideView: View {
  let title: String
  let sections: [GuideSection]

  var body: some View {
    VStack(spacing: 0) {
      Toolbar(title: "\(title) 도움말")
      ScrollView {
        VStack(alignment: .leading, spacing: 32) {
          // MARK: Table of contents
          VStack(alignment: .leading, spacing: 4) {
            Text("목차")
              .fontKoddi(18, color: .light, weight: .bold)

            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
              Text("\(index + 1). \(section.title)")
                .fontKoddi(15, color: .lightGrey)
            }
          }

          // MARK: Section
          ForEach(sections, id: \.id) { section in
            VStack(alignment: .leading, spacing: 5) {
              Text(section.title)
                .fontKoddi(20, weight: .bold)
              divider()
              section.content()
                .fontKoddi(18, color: .lightGrey)
            }
          }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
      }
    }
  }

  @ViewBuilder
  private func divider() -> some View {
    Divider()
      .frame(height: 1)
      .background(.accent)
  }
}

#Preview {
  GuideView(
    title: "코드 학습",
    sections: [
      GuideSection(
        title: "음성 학습 안내",
        content: {
          Text("""
          음성 안내를 통해 코드를 단계별로 학습하는 데 도움을 줍니다.

          사용자가 음성으로 "다시" 또는 "재생"이라고 명령하면 음성 안내를 다시 들을 수 있습니다.

          사용자가 음성으로 "다음"이라고 명령하면 다음 학습 단계로 넘어갈 수 있습니다.

          사용자가 음성으로 "이전"이라고 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.
          """)
        }
      ),
    ]
  )
}
