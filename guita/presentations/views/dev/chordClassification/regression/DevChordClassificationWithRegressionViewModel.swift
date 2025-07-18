//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class DevChordClassificationWithRegressionViewModel: BaseViewModel<DevChordClassificationWithRegressionViewState> {
  private let chordClassificationWithModel = ChordClassificationWithRegression()
  private let audioRecorderManager: AudioRecorderManager = .shared

  init() {
    super.init(state: .init(
      isStarted: false,
      isSilence: false,
      chord: .F,
      pixel: nil
    ))
  }

  func start() {
    if state.isStarted { return }

    Logger.d("Start prediction")
    audioRecorderManager.start { [weak self] buffer, _ in
      guard let self = self else { return }
      if let (chord, _) = chordClassificationWithModel.run(
        buffer: buffer,
        windowSize: self.audioRecorderManager.windowSize
      ) {
        emit(state.copy(
          isStarted: true,
          isSilence: chord == nil,
          chord: chord
        ))
      }
    }
  }

  override func dispose() {
    audioRecorderManager.stop()
  }
}
