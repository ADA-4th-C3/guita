//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { HomeViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(
          title: NSLocalizedString("Guita", comment: ""),
          accessibilityHint: NSLocalizedString("귀로 치는 기타, 귀타가 시작되었습니다. 기타 학습을 시작하기 위해서는 기타 학습 버튼을 눌러주십시오.", comment: ""),
          isPopButton: false,
          trailing: {
            // MARK: Dev Button
            Text("Dev")
              .opacity(0.01)
              .onLongPressGesture {
                router.push(.dev)
              }.accessibilityHidden(true)
          }
        )

        Spacer()
        VStack(spacing: 10) {
          // MARK: Pick image
          Image("pick")
            .resizable()
            .frame(width: 47, height: 54)
            .padding(.bottom, 43)
            .accessibilityHidden(true)

          // MARK: 기타 학습
          Button {
            router.push(.curriculum)
          } label: {
            Text("기타 학습")
              .fontKoddi(32, color: .light, weight: .bold)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(16)
          }
          .accessibilityHint("학습 목록 화면으로 이동")

          // MARK: 설정
          Button {
            router.push(.setting)
          } label: {
            Text("설정")
              .fontKoddi(32, color: .light, weight: .bold)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(16)
          }
          .padding(.top, 8)
          .accessibilityHint("설정 화면으로 이동")
        }
        .offset(y: -80)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
