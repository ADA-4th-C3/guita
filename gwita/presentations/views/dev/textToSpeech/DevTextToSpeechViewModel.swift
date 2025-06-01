//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class DevTextToSpeechViewModel: BaseViewModel<DevTextToSpeechViewState> {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared

  init() {
    super.init(state: .init(
      samples: [
        "E코드는 첫번째, 두 번째 플랫이 사용되고, 3개의 손가락을 사용합니다.",
        "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"라고 말씀해 주세요.",
        "한 줄씩 코드를 잡아봅시다.",
        "첫 번째 플랫, 아래에서 세 번째 줄을  두 번째 손가락으로 잡으세요. 그리고 세 번째 줄을 튕겼을 때",
        "이런 소리가 들려야 해요. 이제 세 번째 줄을 튕겨볼까요?",
      ],
      index: 0,
      isVoiceCommandEnabled: true
    ))
  }

  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: play),
        VoiceCommand(keyword: .retry, handler: play),
        VoiceCommand(keyword: .next, handler: goNext),
        VoiceCommand(keyword: .previous, handler: goPrevious),
      ]
    )
    emit(state.copy(isVoiceCommandEnabled: true))
  }

  func stopVoiceCommand() {
    voiceCommandManager.stop()
    emit(state.copy(isVoiceCommandEnabled: false))
  }

  func play() {
    textToSpeechManager.stop()
    Task {
      let sample = self.state.samples[self.state.index]
      await textToSpeechManager.speak(sample)
    }
  }

  func goNext() {
    emit(state.copy(index: (state.index + 1) % state.samples.count))
    play()
  }

  func goPrevious() {
    emit(state.copy(index: (state.index - 1) % state.samples.count))
    play()
  }

  override func dispose() {
    stopVoiceCommand()
    textToSpeechManager.stop()
  }
}
