//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 노래 목록 화면의 ViewModel
final class SongListViewModel: BaseViewModel<SongListViewState> {
  
  init() {
    super.init(state: SongListViewState())
  }
  
  
  /// 노래 목록을 로드하여 상태를 업데이트
  func loadSongs() {
    Logger.d("노래 목록 로딩 시작")
    
    let songs = SongDataFactory.createDefaultSongs()
    
    emit(state.copy(
      songs: songs,
      isLoading: false
    ))
    
    Logger.d("노래 목록 로딩 완료: \(songs.count)개")
  }
  
  /// 노래 완료 상태 업데이트
  func markSongCompleted(_ songId: String) {
    let updatedSongs = state.songs.map { song in
      if song.id == songId {
        return SongModel(
          id: song.id,
          title: song.title,
          artist: song.artist,
          difficulty: song.difficulty,
          requiredCodes: song.requiredCodes,
          audioFileName: song.audioFileName,
          isUnlocked: song.isUnlocked,
          isCompleted: true // 완료 상태로 변경
        )
      }
      return song
    }
    
    emit(state.copy(songs: updatedSongs))
    Logger.d("노래 완료 처리: \(songId)")
  }
  
  /// 다음 노래 잠금 해제
  func unlockNextSong(after completedSongId: String) {
    guard let completedIndex = state.songs.firstIndex(where: { $0.id == completedSongId }),
          completedIndex + 1 < state.songs.count else {
      Logger.d("다음 노래가 없거나 이미 마지막 노래임")
      return
    }
    
    let nextSongIndex = completedIndex + 1
    var updatedSongs = state.songs
    
    let nextSong = updatedSongs[nextSongIndex]
    updatedSongs[nextSongIndex] = SongModel(
      id: nextSong.id,
      title: nextSong.title,
      artist: nextSong.artist,
      difficulty: nextSong.difficulty,
      requiredCodes: nextSong.requiredCodes,
      audioFileName: nextSong.audioFileName,
      isUnlocked: true, // 잠금 해제
      isCompleted: nextSong.isCompleted
    )
    
    emit(state.copy(songs: updatedSongs))
    Logger.d("다음 노래 잠금 해제: \(nextSong.title)")
  }
}
