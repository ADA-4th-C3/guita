//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionDeniedDialog: View {
  let onConfirm: () -> Void
  let onCancel: () -> Void
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 14) {
        Image("pick-check")
          .resizable()
          .frame(width: 54, height: 54)
          .accessibilityHidden(true)

        Text("음성 명령 기능을 사용할 수 없습니다.")
          .multilineTextAlignment(.center)
          .fontKoddi(17, color: .dark, weight: .bold)

        dividerView()

        Text("음성 명령 기능을 사용하려면\n'음성인식' 접근권한을 허용해야합니다.\n음성 명령 기능을 사용하고 싶으면 '설정'\n버튼을 눌러 '음성인식' 접근을 허용해주세요.")
          .fontKoddi(13, color: .dark)
          .lineSpacing(1.385)
          .multilineTextAlignment(.center)
      }
      .padding(.vertical, 22)
      .padding(.horizontal, 12.5)

      HStack(spacing: 0) {
        // MARK: 나가기
        Button(action: onCancel) {
          Text("나가기")
            .fontKoddi(20, color: .darkGrey, weight: .bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.lLightGrey)
            .foregroundColor(.dark)
            .clipShape(
              RoundedCorner(radius: 10, corners: [.bottomLeft])
            )
        }

        Button(action: onConfirm) {
          Text("설정")
            .fontKoddi(20, color: .dark, weight: .bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.accent)
            .foregroundColor(.dark)
            .clipShape(
              RoundedCorner(radius: 10, corners: [.bottomRight])
            )
        }
      }
    }
    .background(.light)
    .cornerRadius(10)
    .frame(width: 306)
    .onAppear {}
  }

  @ViewBuilder
  private func dividerView() -> some View {
    Rectangle()
      .fill(.lightGrey)
      .frame(height: 1.2)
  }
}

#Preview {
  PermissionDeniedDialog(
    onConfirm: {},
    onCancel: {}
  )
}
