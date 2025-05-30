//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드 학습 목록 화면의 ViewModel
final class CodeLearningListViewModel: BaseViewModel<CodeLearningListViewState> {
  
  init() {
    super.init(state: CodeLearningListViewState(
      lessons: [],
      isLoading: true,
      selectedLessonId: nil
    ))
  }
  // MARK: - Public Methods
  
  /// 레슨 목록을 로드하여 상태를 업데이트
  func loadLessons() {
    Logger.d("레슨 목록 로딩 시작")
    
    let lessons = LessonDataFactory.createDefaultLessons()
    
    emit(state.copy(
      lessons: lessons,
      isLoading: false
    ))
    
    Logger.d("레슨 목록 로딩 완료: \(lessons.count)개")
  }
  
  /// 레슨 완료 상태 업데이트
  func markLessonCompleted(_ lessonId: String) {
    let updatedLessons = state.lessons.map { lesson in
      if lesson.id == lessonId {
        return LessonModel(
          id: lesson.id,
          title: lesson.title,
          subtitle: lesson.subtitle,
          codes: lesson.codes,
          isUnlocked: lesson.isUnlocked,
          isCompleted: true, // 완료 상태로 변경
          codeType: lesson.codeType,
          difficulty: lesson.difficulty
        )
      }
      return lesson
    }
    
    emit(state.copy(lessons: updatedLessons))
    Logger.d("레슨 완료 처리: \(lessonId)")
  }
  
  /// 다음 레슨 잠금 해제
  func unlockNextLesson(after completedLessonId: String) {
    guard let completedIndex = state.lessons.firstIndex(where: { $0.id == completedLessonId }),
          completedIndex + 1 < state.lessons.count else {
      Logger.d("다음 레슨이 없거나 이미 마지막 레슨임")
      return
    }
    
    let nextLessonIndex = completedIndex + 1
    var updatedLessons = state.lessons
    
    let nextLesson = updatedLessons[nextLessonIndex]
    updatedLessons[nextLessonIndex] = LessonModel(
      id: nextLesson.id,
      title: nextLesson.title,
      subtitle: nextLesson.subtitle,
      codes: nextLesson.codes,
      isUnlocked: true, // 잠금 해제
      isCompleted: nextLesson.isCompleted,
      codeType: nextLesson.codeType,
      difficulty: nextLesson.difficulty
    )
    
    emit(state.copy(lessons: updatedLessons))
    Logger.d("다음 레슨 잠금 해제: \(nextLesson.title)")
  }
}

