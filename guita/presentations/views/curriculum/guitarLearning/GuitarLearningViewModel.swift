//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 기타 학습 메인 화면의 ViewModel
final class GuitarLearningViewModel: BaseViewModel<GuitarLearningViewState> {
  
  init() {
    super.init(state: GuitarLearningViewState())
  }
  
  // MARK: - Public Methods
  
  /// 화면이 나타날 때 호출되는 초기화 함수
  func onViewAppear() {
    // 필요시 분석 데이터 수집이나 초기화 로직 추가
    Logger.d("기타 학습 메인 화면 진입")
  }
  
  /// 화면이 사라질 때 호출되는 정리 함수
  func onViewDisappear() {
    // 필요시 정리 로직 추가
    Logger.d("기타 학습 메인 화면 종료")
  }
}

/// 기타 학습 메인 화면의 상태를 관리하는 ViewState
struct GuitarLearningViewState {
  // 현재는 상태가 필요하지 않지만, 향후 확장을 위해 구조 유지
  // 예: 사용자 진행률, 최근 학습 정보 등을 추가할 수 있음
  
  init() {
    // 기본 초기화
  }
}
