//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 기타 학습 메인 화면의 상태를 관리하는 ViewState
struct GuitarLearningViewState {
  let songs: [SongModel]          // 곡 목록
  let isLoading: Bool             // 로딩 상태
  let selectedSongId: String?     // 현재 선택된 곡 ID
  
  func copy(
    songs: [SongModel]? = nil,
    isLoading: Bool? = nil,
    selectedSongId: String? = nil
  ) -> GuitarLearningViewState {
    return GuitarLearningViewState(
      songs: songs ?? self.songs,
      isLoading: isLoading ?? self.isLoading,
      selectedSongId: selectedSongId ?? self.selectedSongId
    )
  }
}
