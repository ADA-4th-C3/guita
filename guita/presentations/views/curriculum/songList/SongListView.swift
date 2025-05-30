//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SongListView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { SongListViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "곡 선택")
        
        // 메인 콘텐츠
        VStack(spacing: 0) {
          // 헤더 섹션
          headerSection
          
          // 노래 목록
          songListSection(viewModel: viewModel, state: state)
        }
      }
      .background(Color.black)
      .onAppear {
        viewModel.loadSongs()
      }
    }
  }
  
  // MARK: - Header Section
  private var headerSection: some View {
    VStack(spacing: 16) {
      Text("기타 학습")
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("연습할 곡을 선택해주세요")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
  }
  
  // MARK: - Song List Section
  private func songListSection(
    viewModel: SongListViewModel,
    state: SongListViewState
  ) -> some View {
    ScrollView {
      LazyVStack(spacing: 1) {
        ForEach(state.songs) { song in
          SongRowView(song: song) {
            handleSongTap(song: song)
          }
        }
      }
    }
    .padding(.top, 20)
  }
  
  private func handleSongTap(song: SongModel) {
    guard song.isUnlocked else {
      Logger.d("잠금된 곡 선택됨: \(song.title)")
      return
    }
    
    Logger.d("곡 선택됨: \(song.title)")
    router.push(.learningOptions(song))
  }
}
