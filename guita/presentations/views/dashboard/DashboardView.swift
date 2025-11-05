//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var router: Router
  @AccessibilityFocusState private var focusedItem: String?

  var body: some View {
    BaseView(
      create: {
        DashboardViewModel()
      }
    ) { _, _ in
      ZStack {
        VStack(spacing: 0) {
          toolbar
            .accessibilityElement(children: .contain)

          dashboardList

          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          focusedItem = nil
        }
      }
    }
  }

  private var toolbar: some View {
    Toolbar(
      titlePrefix: {
        Image("titleIcon")
          .resizable()
          .scaledToFit()
          .frame(width: 44, height: 44)
          .accessibilityHidden(true)
      },
      title: "Guita",
      isPopButton: false,
      firstTrailing: {
        IconButton("info") {
//          router.push(.chordLessonGuide)
        }.accessibilityAddTraits(.isButton)
          .accessibilityLabel("사용법 도움말")
          .accessibilityFocused($focusedItem, equals: "info")
      },
      secondTrailing: {
        IconButton("gearshape", isSystemImage: true) {
          router.push(.setting)
        }.accessibilityAddTraits(.isButton)
          .accessibilityHint("설정 화면으로 이동")
          .accessibilityFocused($focusedItem, equals: "setting")
      }
    )
  }

  private var dashboardList: some View {
    VStack(spacing: 0) {
      ListDivider()

      Button(action: {
        // TODO: - 기타튜닝 routing
        // router.push()
      }) {
        Text("기타 튜닝")
          .fontKoddi(
            26,
            color: focusedItem == "guitarTuining" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("기타 튜닝하기")
          .frame(height: 110)
          .frame(maxWidth: .infinity)
          .background(focusedItem == "guitarTuining" ? Color.accent : Color.clear)
      }
      .accessibilityFocused($focusedItem, equals: "guitarTuining")

      ListDivider()

      Button(action: {
        router.push(.chordCategory)
      }) {
        Text("전체 코드 학습")
          .fontKoddi(
            26,
            color: focusedItem == "totalChordLearning" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("전체 코드 학습하기")
          .frame(height: 110)
          .frame(maxWidth: .infinity)
          .background(focusedItem == "totalChordLearning" ? Color.accent : Color.clear)
      }
      .accessibilityFocused($focusedItem, equals: "totalChordLearning")
      ListDivider()

      Button(action: {
        router.push(.curriculum)
      }) {
        Text("곡 연습")
          .fontKoddi(
            26,
            color: focusedItem == "songLearning" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("곡 연습하기")
          .frame(height: 110)
          .frame(maxWidth: .infinity)
          .background(focusedItem == "songLearning" ? Color.accent : Color.clear)
      }
      .accessibilityFocused($focusedItem, equals: "songLearning")
      ListDivider()
    }
  }
}

#Preview {
  BasePreview {
    DashboardView()
  }
}
