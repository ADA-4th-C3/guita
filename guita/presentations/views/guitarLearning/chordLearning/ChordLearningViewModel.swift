//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드 학습 목록 화면의 ViewModel
final class ChordLearningListViewModel: BaseViewModel<ChordLearningListViewState> {
  
  init() {
    super.init(state: ChordLearningListViewState(
      chordLessons: [],
      isLoading: true,
      selectedLessonId: nil
    ))
  }
  
  // MARK: - Public Methods
  
  /// 코드 레슨 목록을 로드하여 상태를 업데이트
  func loadChordLessons() {
    Logger.d("코드 레슨 목록 로딩 시작")
    
    let chordLessons = ChordLessonDataFactory.createDefaultChordLessons()
    
    emit(state.copy(
      chordLessons: chordLessons,
      isLoading: false
    ))
    
    Logger.d("코드 레슨 목록 로딩 완료: \(chordLessons.count)개")
  }
  
  /// 코드 레슨 완료 상태 업데이트
  func markChordLessonCompleted(_ lessonId: String) {
    let updatedLessons = state.chordLessons.map { lesson in
      if lesson.id == lessonId {
        return ChordLessonModel(
          id: lesson.id,
          chordType: lesson.chordType,  // <#T##Chord#> 제거하고 lesson.chordType으로 수정
          difficulty: lesson.difficulty,
          isUnlocked: lesson.isUnlocked,
          isCompleted: true, // 완료 상태로 변경
          description: lesson.description
        )
      }
      return lesson
    }
    
    emit(state.copy(chordLessons: updatedLessons))
    Logger.d("코드 레슨 완료 처리: \(lessonId)")
  }
  
  /// 다음 코드 레슨 잠금 해제
  func unlockNextChordLesson(after completedLessonId: String) {
    guard let completedIndex = state.chordLessons.firstIndex(where: { $0.id == completedLessonId }),
          completedIndex + 1 < state.chordLessons.count else {
      Logger.d("다음 코드 레슨이 없거나 이미 마지막 레슨임")
      return
    }
    
    let nextLessonIndex = completedIndex + 1
    var updatedLessons = state.chordLessons
    
    let nextLesson = updatedLessons[nextLessonIndex]
    updatedLessons[nextLessonIndex] = ChordLessonModel(
      id: nextLesson.id,
      chordType: nextLesson.chordType,
      difficulty: nextLesson.difficulty,
      isUnlocked: true, // 잠금 해제
      isCompleted: nextLesson.isCompleted,
      description: nextLesson.description
    )
    
    emit(state.copy(chordLessons: updatedLessons))
    Logger.d("다음 코드 레슨 잠금 해제: \(nextLesson.title)")
  }
  
  /// 특정 코드 타입의 레슨 반환
  func getChordLesson(for chord: Chord) -> ChordLessonModel? {  // codeType: chord → chord: Chord
    return state.chordLessons.first { $0.chordType == chord }
  }
  
  /// 난이도별 코드 레슨 필터링
  func getChordLessons(for difficulty: ChordDifficulty) -> [ChordLessonModel] {
    return state.chordLessons.filter { $0.difficulty == difficulty }
  }
}

