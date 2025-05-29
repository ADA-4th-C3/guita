//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import SoundAnalysis

// CoreML 사운드 분석용 Observer (나중에 사용)
class SoundResultObserver: NSObject, SNResultsObserving {
  weak var viewModel: VoiceControlViewModel?
  
  init(viewModel: VoiceControlViewModel) {
    self.viewModel = viewModel
  }
  
  func request(_: SNRequest, didProduce result: SNResult) {
    guard let result = result as? SNClassificationResult else { return }
    
    // 가장 높은 결과만 뷰모델에 전달
    if let best = result.classifications.first {
      viewModel?.updatePrediction(best.identifier, confidence: best.confidence)
    }
  }
  
  func request(_: SNRequest, didFailWithError error: Error) {
    Logger.e("분석 실패: \(error)")
  }
  
  func requestDidComplete(_: SNRequest) {}
}
