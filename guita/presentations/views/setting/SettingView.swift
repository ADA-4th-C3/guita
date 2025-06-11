//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SettingView: View {
  var body: some View {
    BaseView(
      create: { SettingViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Config")

        VStack(spacing: 0) {
          ListDivider()

          // MARK: 음성 명령 섹션
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("음성 명령")
                .font(.headline)
                .padding(.bottom, 4)
                .foregroundColor(.white)
              Text("음성 명령은 기능 제어시 사용됩니다")
                .font(.subheadline)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.gray)
            }
            Spacer()
            Toggle("", isOn: Binding(
              get: { viewModel.effectiveVoiceCommandEnabled },
              set: { enabled in
                if !viewModel.hasVoicePermission, enabled {
                  viewModel.openSettings()
                } else {
                  viewModel.updateUserWantsVoiceCommand(enabled)
                }
              }))
          }
          .padding()
          .frame(minHeight: 90)

          ListDivider()

          // MARK: 강의 속도 조절 섹션
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("강의 속도 조절")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 4)
              Text("x\(state.ttsSpeed.value.formatted(2))")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: 0) {
              Button("-") {
                viewModel.updateTtsSpeed(isSpeedUp: false)
              }
              .frame(width: 50, height: 40)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(.white)
              .font(.title2)

              Button("+") {
                viewModel.updateTtsSpeed(isSpeedUp: true)
              }
              .frame(width: 50, height: 40)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(.white)
              .font(.title2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          .padding()
          .frame(minHeight: 90)

          ListDivider()
        }

        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    SettingView()
  }
}
