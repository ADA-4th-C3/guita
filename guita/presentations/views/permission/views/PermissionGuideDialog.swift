//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionGuideDialog: View {
  let onConfirm: () -> Void
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 14) {
        Image("pick-check")
          .resizable()
          .frame(width: 54, height: 54)
          .accessibilityHidden(true)

        Text("귀타 앱의 편리한 이용을 위해\n아래 접근권한의 허용이 필요합니다.")
          .accessibilityAddTraits(.isHeader)
          .multilineTextAlignment(.center)
          .fontKoddi(17, color: .dark, weight: .bold)

        dividerView()

        VStack(alignment: .leading, spacing: 18) {
          VStack(alignment: .leading, spacing: 7) {
            Text("음성 인식(필수)")
              .fontKoddi(15, color: .dark, weight: .bold)
            Text("음성 명령으로 기능 제어시 사용")
              .fontKoddi(13, color: .dark)
          }
          .accessibilityElement(children: .ignore)
          .accessibilityLabel("기타를 연주하면서 음성 명령으로 앱을 제어하기 위해 음성 인식 권한이 필요합니다.")

          VStack(alignment: .leading, spacing: 7) {
            Text("마이크(필수)")
              .fontKoddi(15, color: .dark, weight: .bold)
            Text("기타 연주 소리를 듣고 학습 피드백을 드리기 위해 마이크 접근 권한이 필요")
              .fontKoddi(13, color: .dark)
          }
          .accessibilityElement(children: .ignore)
          .accessibilityLabel("기타 연주 소리를 듣고 학습 피드백을 드리기 위해 마이크 접근 권한이 필요합니다.")
        }
        dividerView()

        Text("* 설정 > 귀타 앱에서 권한 변경이 가능합니다.")
          .fontKoddi(13, color: .darkGrey)
          .accessibilityLabel("설정 내부의 귀타 앱에서 권한 변경이 가능합니다.")
      }
      .padding(.vertical, 22)
      .padding(.horizontal, 12.5)

      Button(action: onConfirm) {
        Text("확인")
          .accessibilityLabel("접근 권한 요청하기")
          .fontKoddi(20, color: .dark, weight: .bold)
          .frame(maxWidth: .infinity)
          .padding()
          .background(.accent)
          .foregroundColor(.dark)
          .clipShape(
            RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
          )
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
  PermissionGuideDialog {}
}
