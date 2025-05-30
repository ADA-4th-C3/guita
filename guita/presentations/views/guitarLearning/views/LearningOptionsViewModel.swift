//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 학습 옵션 선택 화면의 ViewModel (ChordLessonModel 대응)
final class LearningOptionsViewModel: BaseViewModel<LearningOptionsViewState> {
  
  private let song: SongModel
  private let chordLessons: [ChordLessonModel]
  
  // MARK: - Factory Method
  
  static func create(song: SongModel) -> LearningOptionsViewModel {
    return LearningOptionsViewModel(song: song)
  }
  
  // MARK: - Initializer
  
  private init(song: SongModel) {
    self.song = song
    self.chordLessons = ChordLessonDataFactory.createDefaultChordLessons()
    
    // State 생성을 ViewModel에서 처리
    let initialState = LearningOptionsViewState(
      selectedSong: song,
      selectedOption: nil,
      isLoading: false
    )
    
    super.init(state: initialState)
    Logger.d("LearningOptionsViewModel 초기화: \(song.title)")
  }
  
  // MARK: - Public Methods
  
  /// 학습 옵션 선택 처리
  func selectLearningOption(_ option: LearningOption) {
    Logger.d("학습 옵션 선택: \(option)")
    emit(state.copy(selectedOption: option))
  }
  
  // MARK: - Business Logic Methods
  
  /// 사용 가능한 학습 옵션들 반환
  var availableOptions: [LearningOption] {
    return LearningOption.allCases
  }
  
  /// 코드 학습이 가능한지 여부
  var canLearnCodes: Bool {
    return !song.requiredCodes.isEmpty
  }
  
  /// 첫 번째 학습할 코드
  var firstCodeToLearn: CodeType? {
    return song.requiredCodes.first
  }
  
  /// 첫 번째 학습할 코드의 레슨 정보
  var firstChordLesson: ChordLessonModel? {
    guard let firstCode = firstCodeToLearn else { return nil }
    return chordLessons.first { $0.chordType == firstCode }
  }
  
  /// 노래에 필요한 모든 코드 레슨들
  var requiredChordLessons: [ChordLessonModel] {
    return chordLessons.filter { chordLesson in
      song.requiredCodes.contains(chordLesson.chordType)
    }
  }
  
  /// 난이도별 권장 학습 순서
  var recommendedLearningOrder: [LearningOption] {
    switch song.difficulty {
    case .beginner:
      return [.code, .section, .technique, .fullSong]
    case .intermediate:
      return [.code, .technique, .section, .fullSong]
    case .advanced:
      return [.technique, .code, .section, .fullSong]
    }
  }
  
  /// 학습 옵션이 활성화되어 있는지 여부
  func isOptionEnabled(_ option: LearningOption) -> Bool {
    switch option {
    case .code:
      return canLearnCodes
    case .technique, .section, .fullSong:
      return true
    }
  }
  
  /// 학습 옵션 제목
  func titleForOption(_ option: LearningOption) -> String {
    switch option {
    case .code: return "코드 학습"
    case .technique: return "주법 학습"
    case .section: return "곡 구간 학습"
    case .fullSong: return "곡 전체 학습"
    }
  }
  
  /// 학습 옵션 부제목
  func subtitleForOption(_ option: LearningOption) -> String {
    switch option {
    case .code:
      if canLearnCodes {
        let chordNames = requiredChordLessons.map { $0.chordType.rawValue }.joined(separator: ", ")
        let totalFingers = requiredChordLessons.reduce(0) { $0 + $1.fingerPositions.count }
        return "필요한 코드: \(chordNames)\n총 \(totalFingers)개 손가락 위치 학습"
      } else {
        return "학습할 코드가 없습니다"
      }
    case .technique:
      return "다양한 연주 기법을 익혀보세요"
    case .section:
      return "곡의 일부분을 집중 연습하세요"
    case .fullSong:
      return "완전한 곡을 연주해보세요"
    }
  }
  
  /// 학습 옵션이 하이라이트되어야 하는지 여부
  func isOptionHighlighted(_ option: LearningOption) -> Bool {
    guard let firstRecommended = recommendedLearningOrder.first else { return false }
    return option == firstRecommended
  }
  
  /// 코드 학습 시 추가 정보 제공
  func getChordLearningInfo() -> String {
    guard canLearnCodes else { return "" }
    
    let beginnerCount = requiredChordLessons.filter { $0.difficulty == .beginner }.count
    let intermediateCount = requiredChordLessons.filter { $0.difficulty == .intermediate }.count
    let advancedCount = requiredChordLessons.filter { $0.difficulty == .advanced }.count
    
    var info = "난이도별 코드 분포: "
    var parts: [String] = []
    
    if beginnerCount > 0 { parts.append("초급 \(beginnerCount)개") }
    if intermediateCount > 0 { parts.append("중급 \(intermediateCount)개") }
    if advancedCount > 0 { parts.append("고급 \(advancedCount)개") }
    
    info += parts.joined(separator: ", ")
    return info
  }
}
