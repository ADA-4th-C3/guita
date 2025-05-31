//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 기타 학습 메인 화면의 ViewModel
final class GuitarLearningViewModel: BaseViewModel<GuitarLearningViewState> {
  
  init() {
    super.init(state: GuitarLearningViewState(
      songs: [],
      isLoading: true,
      selectedSongId: nil
    ))
  }
  
  // MARK: - Public Methods
  
  /// 곡 목록을 로드하여 상태를 업데이트
  func loadSongs() {
    Logger.d("곡 목록 로딩 시작")
    
    let songs = SongDataFactory.createDefaultSongs()
    
    emit(state.copy(
      songs: songs,
      isLoading: false
    ))
    
    Logger.d("곡 목록 로딩 완료: \(songs.count)개")
  }
  
  /// 화면이 나타날 때 호출되는 초기화 함수
  func onViewAppear() {
    Logger.d("기타 학습 메인 화면 진입")
  }
  
  /// 화면이 사라질 때 호출되는 정리 함수
  func onViewDisappear() {
    Logger.d("기타 학습 메인 화면 종료")
  }
  
  
}
