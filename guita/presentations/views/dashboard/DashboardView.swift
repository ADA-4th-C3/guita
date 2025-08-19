//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var router: Router
  @State var selected: String? = nil

  var body: some View {
    BaseView(
      create: {
        DashboardViewModel()
      }
    ) { _, _ in
      ZStack {
        VStack(spacing: 0) {
          toolbar

          dashboardList

          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          selected = nil
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
      },
      secondTrailing: {
        IconButton("gearshape", isSystemImage: true) {
          router.push(.setting)
        }.accessibilityAddTraits(.isButton)
          .accessibilityHint("설정 화면으로 이동")
      }
    )
  }

  private var dashboardList: some View {
    VStack(spacing: 0) {
      ListDivider()

      Button(action: {
        // TODO: - 기타튜닝 routing
        // router.push()
        selected = "guitarTuining"
      }) {
        Text("기타 튜닝")
          .fontKoddi(
            26,
            color: selected == "guitarTuining" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("기타 튜닝하기")
      }
      .frame(height: 110)
      .frame(maxWidth: .infinity)
      .if(selected == "guitarTuining") {
        v in v.background(.accent)
      }

      ListDivider()

      Button(action: {
        router.push(.chordCategory)
        selected = "totalChordLearning"
      }) {
        Text("전체 코드 학습")
          .fontKoddi(
            26,
            color: selected == "totalChordLearning" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("전체 코드 학습하기")
      }
      .frame(height: 110)
      .frame(maxWidth: .infinity)
      .if(selected == "totalChordLearning") {
        v in v.background(.accent)
      }
      ListDivider()

      Button(action: {
        router.push(.curriculum)
        selected = "songLearning"
      }) {
        Text("곡 연습")
          .fontKoddi(
            26,
            color: selected == "songLearning" ? .black : .lightGrey,
            weight: .bold
          )
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("곡 연습하기")
      }
      .frame(height: 110)
      .frame(maxWidth: .infinity)
      .if(selected == "songLearning") {
        v in v.background(.accent)
      }
      ListDivider()
    }
  }
}

#Preview {
  BasePreview {
    DashboardView()
  }
}
