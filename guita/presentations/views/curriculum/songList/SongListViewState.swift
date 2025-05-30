//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 노래 목록 화면의 상태
struct SongListViewState {
  let songs: [SongModel]          // 노래 목록
  let isLoading: Bool             // 로딩 상태
  let selectedSongId: String?     // 현재 선택된 노래 ID
  
  init(
    songs: [SongModel] = [],
    isLoading: Bool = true,
    selectedSongId: String? = nil
  ) {
    self.songs = songs
    self.isLoading = isLoading
    self.selectedSongId = selectedSongId
  }
  
  func copy(
    songs: [SongModel]? = nil,
    isLoading: Bool? = nil,
    selectedSongId: String? = nil
  ) -> SongListViewState {
    return SongListViewState(
      songs: songs ?? self.songs,
      isLoading: isLoading ?? self.isLoading,
      selectedSongId: selectedSongId ?? self.selectedSongId
    )
  }
}
