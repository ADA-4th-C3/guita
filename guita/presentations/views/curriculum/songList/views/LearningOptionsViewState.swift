//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 학습 옵션 선택 화면의 상태를 관리하는 ViewState
struct LearningOptionsViewState {
  
  // MARK: - Properties
  
  let selectedSong: SongModel           // 선택된 노래 정보
  let selectedOption: LearningOption?   // 현재 선택된 학습 옵션
  let isLoading: Bool                   // 로딩 상태
  
  // MARK: - Copy Method
  
  func copy(
    selectedSong: SongModel? = nil,
    selectedOption: LearningOption? = nil,
    isLoading: Bool? = nil
  ) -> LearningOptionsViewState {
    return LearningOptionsViewState(
      selectedSong: selectedSong ?? self.selectedSong,
      selectedOption: selectedOption ?? self.selectedOption,
      isLoading: isLoading ?? self.isLoading
    )
  }
}

/// 학습 옵션 타입
enum LearningOption: CaseIterable {
  case code      // 코드 학습
  case technique // 주법 학습
  case section   // 곡 구간 학습
  case fullSong  // 곡 전체 학습
}
