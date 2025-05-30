//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.


/// 코드 학습 목록 화면의 상태
struct CodeLearningListViewState {
  let lessons: [LessonModel]
  let isLoading: Bool
  let selectedLessonId: String?
  
  func copy(
    lessons: [LessonModel]? = nil,
    isLoading: Bool? = nil,
    selectedLessonId: String? = nil
  ) -> CodeLearningListViewState {
    return CodeLearningListViewState(
      lessons: lessons ?? self.lessons,
      isLoading: isLoading ?? self.isLoading,
      selectedLessonId: selectedLessonId ?? self.selectedLessonId
    )
  }
}
