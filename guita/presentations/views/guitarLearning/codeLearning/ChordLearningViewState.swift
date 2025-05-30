//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.


/// 코드 학습 목록 화면의 상태
struct ChordLearningListViewState {
  let chordLessons: [ChordLessonModel]    // 코드 레슨 목록
  let isLoading: Bool                     // 로딩 상태
  let selectedLessonId: String?           // 현재 선택된 레슨 ID
  
  func copy(
    chordLessons: [ChordLessonModel]? = nil,
    isLoading: Bool? = nil,
    selectedLessonId: String? = nil
  ) -> ChordLearningListViewState {
    return ChordLearningListViewState(
      chordLessons: chordLessons ?? self.chordLessons,
      isLoading: isLoading ?? self.isLoading,
      selectedLessonId: selectedLessonId ?? self.selectedLessonId
    )
  }
}
