//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SettingView: View {
  var body: some View {
    BaseView(
      create: { SettingViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: NSLocalizedString("설정", comment: ""))

        VStack(spacing: 0) {
          ListDivider()

          // MARK: 음성 명령 섹션
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("음성 명령")
                .font(.headline)
                .padding(.bottom, 4)
                .foregroundColor(.white)
              Text("음성으로 앱의 기능을 제어하는 기능입니다.")
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
          .accessibilityElement(children: .ignore)
          .accessibilityLabel("음성 명령 사용")
          .accessibilityAddTraits(.isToggle)
          .accessibilityValue(
            state.isVoiceCommandEnabled ? "ON" : "OFF"
          )
          .accessibilityHint("학습 화면에서 음성으로 앱의 일부 기능을 제어할 수 있습니다.")

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
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("강의 속도 조절")
            .accessibilityValue(
              String(
                format: NSLocalizedString("TTSSpeed", comment: ""),
                "\(state.ttsSpeed.value.formatted(2))"
              )
            )
            Spacer()

            // MARK: 조절 Buttons
            HStack(spacing: 0) {
              Button("-") {
                viewModel.updateTtsSpeed(isSpeedUp: false)
              }
              .frame(width: 50, height: 40)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(.white)
              .font(.title2)
              .accessibilityLabel("속도 감소")

              RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 18)
                .foregroundColor(.llLightGrey)

              Button("+") {
                viewModel.updateTtsSpeed(isSpeedUp: true)
              }
              .frame(width: 50, height: 40)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(.white)
              .font(.title2)
              .accessibilityLabel("속도 증가")
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
