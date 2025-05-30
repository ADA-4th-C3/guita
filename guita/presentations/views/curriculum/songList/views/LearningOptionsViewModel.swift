//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 학습 옵션 선택 화면의 ViewModel
final class LearningOptionsViewModel: BaseViewModel<LearningOptionsViewState> {
  
  private let song: SongModel
  
  // MARK: - Factory Method
  
  static func create(song: SongModel) -> LearningOptionsViewModel {
    return LearningOptionsViewModel(song: song)
  }
  
  // MARK: - Initializer
  
  private init(song: SongModel) {
    self.song = song
    
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
      return canLearnCodes ? "필요한 코드: \(song.requiredCodes.map { $0.rawValue }.joined(separator: ", "))" : "학습할 코드가 없습니다"
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
}
