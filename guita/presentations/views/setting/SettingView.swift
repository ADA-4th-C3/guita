//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SettingView: View {
  var body: some View {
    BaseView(
      create: { SettingViewModel() }
    ) { viewModel, state in
      GeometryReader { geo in
        VStack {
          // MARK: Toolbar
          toolBar

          VStack(spacing: 0) {
            ListDivider()

            // MARK: 음성 명령 섹션
            voiceCommandSection(
              size: geo.size,
              enabled: viewModel.effectiveVoiceCommandEnabled,
              onToggle: { enabled in
                viewModel.updateUserWantsVoiceCommand(enabled)
              }
            )

            ListDivider()

            // MARK: 강의 속도 조절 섹션
            lectureSpeedSection(
              speedText: state.config.ttsSpeed.value.formatted(2),
              onDecrease: { viewModel.updateTtsSpeed(isSpeedUp: false) },
              onIncrease: { viewModel.updateTtsSpeed(isSpeedUp: true) }
            )

            ListDivider()
          }

          Spacer()
        }
        .frame(maxWidth: geo.size.width, minHeight: 90)
        .accessibilityElement(children: .contain)
        .accessibilityHidden(state.showGuideDialog)

        // MARK: Background + Guide dialog
        if state.showGuideDialog {
          Color.dark.opacity(0.2)
            .ignoresSafeArea()
          PermissionGuideDialog(
            onConfirm: {
              withAnimation {
                viewModel.hideGuideDialog()
              }
              viewModel.requestPermissions()
            }
          )
        }

        // MARK: Denied dialog
        if state.showDeniedDialog {
          PermissionDeniedDialog(
            onConfirm: viewModel.openSettings,
            onCancel: viewModel.onDeniedDialogCanceled
          )
        }
      }
    }
  }

  private var toolBar: some View {
    Toolbar(title: NSLocalizedString("설정", comment: ""))
  }

  private func voiceCommandSection(size: CGSize, enabled: Bool, onToggle: @escaping (Bool) -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("음성 명령")
          .font(.headline)
          .padding(.bottom, 4)
          .foregroundColor(.white)
        Text("음성으로 앱의 기능을 제어하는 기능입니다.")
          .font(.subheadline)
          .frame(width: size.width * 0.7, alignment: .leading)
          .foregroundColor(.gray)
      }
      Toggle("", isOn: Binding(
        get: { enabled },
        set: { onToggle($0) }
      ))
    }
    .padding()
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("음성 명령 사용")
    .accessibilityAddTraits(.isToggle)
    .accessibilityValue(
      enabled ? "ON" : "OFF"
    )
    .accessibilityHint("학습 화면에서 음성으로 앱의 일부 기능을 제어할 수 있습니다.")
  }

  private func lectureSpeedSection(speedText: String, onDecrease: @escaping () -> Void, onIncrease: @escaping () -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("강의 속도 조절")
          .font(.headline)
          .foregroundColor(.white)
          .padding(.bottom, 4)
        Text("x\(speedText)")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("강의 속도 조절")
      .accessibilityValue(
        String(
          format: NSLocalizedString("TTSSpeed", comment: ""),
          "\(speedText)"
        )
      )

      Spacer()

      HStack(spacing: 0) {
        Button("-") {
          onDecrease()
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
          onIncrease()
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
  }
}

#Preview {
  BasePreview {
    SettingView()
  }
}
