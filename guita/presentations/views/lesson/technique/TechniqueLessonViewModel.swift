//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueLessonViewModel: BaseViewModel<TechniqueLessonViewState> {
  private let router: Router
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared
  private var playTask: Task<Void, Error>? = nil

  init(_ router: Router) {
    self.router = router
    let steps: [TechniqueLessonStep] = [
      TechniqueLessonStep(
        description: NSLocalizedString("기타 주법과 스트로크에 대한 소개", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("주법은 코드를 잡지 않은 다른 손으로 기타 줄을 연주하는 방법을 말합니다. 손이나 피크로 줄을 위아래로 쓸듯이 쳐서 리듬감 있게 연주하는 방법인 스트로크를 배워봅시다.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("ChordLesson.VoiceCommandGuide", comment: "")
      ),
      TechniqueLessonStep(
        description: NSLocalizedString("기타의 사운드 홀에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("기타 몸통에 있는 구멍을 사운드 홀이라고 부릅니다. 사운드 홀을 찾아보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: ""
      ),
      TechniqueLessonStep(
        description: NSLocalizedString("주법의 다운에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [
          TechniqueLessonSubStep(ttsText: NSLocalizedString("사운드 홀 위에서 아무 코드를 잡지 않은 상태로 6번 줄부터 1번 줄까지 아래 방향으로 모든 줄을 쓸어내리면 이런 소리가 납니다.", comment: ""), audioFile: .stroke_down, delayAfter: nil, speechRate: nil),

          TechniqueLessonSubStep(ttsText: NSLocalizedString("이것을 다운 스트로크라고 해요. 줄을 쓸어내려 다운 스트로크를 연주해보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: ""
      ),
      TechniqueLessonStep(
        description: NSLocalizedString("주법의 업에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [
          TechniqueLessonSubStep(ttsText: NSLocalizedString("이번엔 1번 줄부터 6번 줄까지 위쪽 방향으로 줄을 쓸어올려 볼게요. 그러면 이런 소리가 납니다.", comment: ""), audioFile: .stroke_up, delayAfter: nil, speechRate: nil),

          TechniqueLessonSubStep(ttsText: NSLocalizedString("이것을 업 스트로크라고 해요. 줄을 쓸어올려 업 스트로크를 연주해보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: ""
      ),

      TechniqueLessonStep(
        description: NSLocalizedString("칼립소 리듬에 대한 설명", comment: ""),
        imageName: "audio-file",
        subSteps: [
          TechniqueLessonSubStep(ttsText: NSLocalizedString("업과 다운을 조합하여 다양한 리듬을 만들 수 있어요. 가장 많이 사용되는 칼립소 리듬을 알려줄게요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
          TechniqueLessonSubStep(ttsText: NSLocalizedString("다운, 다운업, 업, 다운업", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
          TechniqueLessonSubStep(ttsText: NSLocalizedString("여러번 들어보며 다운과 업의 순서를 익혀보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: ""
      ),
      TechniqueLessonStep(
        description: NSLocalizedString("칼립소 리듬에 대한 설명", comment: ""),
        imageName: "audio-file",
        subSteps: [
          TechniqueLessonSubStep(ttsText: NSLocalizedString("칼립소 리듬을 기타로 연주하면 ", comment: ""), audioFile: .stroke_calipso, delayAfter: nil, speechRate: nil),

          TechniqueLessonSubStep(ttsText: NSLocalizedString("이렇게 들립니다. 칼립소 리듬을 연주해 보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: ""
      ),
      TechniqueLessonStep(
        description: NSLocalizedString("주법 학습이 완료되었습니다.", comment: ""),
        imageName: "",
        subSteps: [
          TechniqueLessonSubStep(ttsText: NSLocalizedString("주법 학습이 완료되었습니다.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: ""
      ),
    ]
    super.init(
      state: TechniqueLessonViewState(
        isPermissionGranted: false,
        currentStepIndex: 0,
        steps: steps
      )
    )
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: { self.play() }),
        VoiceCommand(keyword: .retry, handler: { self.play(isRetry: true) }),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
        VoiceCommand(keyword: .stop, handler: dispose),
      ]
    )
  }

  func stopVoiceCommand() {
    voiceCommandManager.stop()
    textToSpeechManager.stop()
  }

  func play(isRetry: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      do {
        try await Task.sleep(nanoseconds: 100_000_000)

        let currentStep = state.steps[state.currentStepIndex]
        let stepNumber = state.currentStepIndex + 1
        let step = String(
          format: NSLocalizedString("ChordLesson.OnlyCurrentStep", comment: ""),
          stepNumber.ordinal
        )
        await textToSpeechManager.speak(step)
        for subStep in currentStep.subSteps {
          try Task.checkCancellation()
          if let ttsText = subStep.ttsText {
            await voiceCommandManager.pause {
              if let rate = subStep.speechRate {
                await self.textToSpeechManager.speak(ttsText, rate: rate)
              } else {
                await self.textToSpeechManager.speak(ttsText)
              }
            }
            if let delay = subStep.delayAfter {
              try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
          }
          try Task.checkCancellation()
          if let audioFile = subStep.audioFile {
            await AudioPlayerManager.shared.start(audioFile: audioFile)
          }
        }
        if !isRetry {
          await voiceCommandManager.pause {
            await self.textToSpeechManager.speak(currentStep.featureDescription)
          }
        }
      } catch {
        textToSpeechManager.stop()
        AudioPlayerManager.shared.stop()
      }
    }
  }

  override func dispose() {
    cancelPlayTask()
    stopVoiceCommand()
    textToSpeechManager.stop()
  }

  func nextStep() {
    if state.isLastStep {
      router.pop()
      return
    }

    cancelPlayTask()
    guard state.currentStepIndex < state.steps.count - 1 else { return }

    let newIndex = state.currentStepIndex + 1
    emit(state.copy(currentStepIndex: newIndex))
    playStepChangeSound {
      self.play()
    }
  }

  func previousStep() {
    cancelPlayTask()
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    playStepChangeSound {
      self.play()
    }
  }

  private func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await AudioPlayerManager.shared.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }

  /// 권한 승인
  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    DispatchQueue.main.async {
      self.emit(self.state.copy(isPermissionGranted: true))
      self.startVoiceCommand()
    }
  }

  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }

  private static func calcDelay(for text: String, speechRate: Float, targetBeat: TimeInterval = 0.6) -> TimeInterval {
    let baseDuration = Double(text.count) * 0.065 / Double(speechRate)
    let delay = max(0.0, targetBeat - baseDuration)
    return delay
  }
}
