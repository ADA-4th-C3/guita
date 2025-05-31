//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 학습 옵션 선택 화면
struct LearningOptionsView: View {
  let song: SongModel
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: {
        LearningOptionsViewModel.create(song: song)
      }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "학습 방법 선택")
        
        // 메인 콘텐츠
        VStack(spacing: 20) {
          Spacer()
          
          // 선택된 곡 정보
          selectedSongInfo(song: state.selectedSong)
          
          // 학습 옵션 버튼들
          learningOptionsSection(viewModel: viewModel, state: state)
          
          Spacer()
        }
        .padding(.horizontal, 24)
      }
      .background(Color.black)
    }
  }
  
  // MARK: - Selected Song Info
  
  /// 선택된 곡 정보 카드
  private func selectedSongInfo(song: SongModel) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(song.displayTitle)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
        
        Text("아티스트: \(song.artist)")
          .font(.caption)
          .foregroundColor(.black.opacity(0.7))
        
        // 코드 태그들
        HStack(spacing: 8) {
          ForEach(song.requiredCodes, id: \.self) { code in
            codeTag(code.rawValue)
          }
        }
      }
      
      Spacer()
    }
    .padding(16)
    .background(Color.yellow)
    .cornerRadius(12)
  }
  
  /// 개별 코드 태그
  private func codeTag(_ code: String) -> some View {
    Text(code)
      .font(.caption)
      .fontWeight(.medium)
      .foregroundColor(.black)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(Color.white)
      .cornerRadius(4)
  }
  
  // MARK: - Learning Options Section
  
  /// 학습 옵션 버튼들 섹션
  private func learningOptionsSection(
    viewModel: LearningOptionsViewModel,
    state: LearningOptionsViewState
  ) -> some View {
    VStack(spacing: 16) {
      ForEach(viewModel.availableOptions, id: \.self) { option in
        LearningOptionButton(
          title: viewModel.titleForOption(option),
          subtitle: viewModel.subtitleForOption(option),
          isHighlighted: viewModel.isOptionHighlighted(option)
        ) {
          handleOptionSelection(
            option: option,
            viewModel: viewModel,
            state: state
          )
        }
        .disabled(!viewModel.isOptionEnabled(option))
        .opacity(viewModel.isOptionEnabled(option) ? 1.0 : 0.5)
      }
    }
  }
  
  // MARK: - Private Methods
  
  /// 학습 옵션 선택 처리
  private func handleOptionSelection(
    option: LearningOption,
    viewModel: LearningOptionsViewModel,
    state: LearningOptionsViewState
  ) {
    viewModel.selectLearningOption(option)
    
    switch option {
    case .code:
      if let firstCode = viewModel.firstCodeToLearn {
        router.push(.codeDetail(state.selectedSong, firstCode))
      }
    case .technique:
      router.push(.techniqueDetail(state.selectedSong))
    case .section:
      router.push(.sectionPractice(state.selectedSong))
    case .fullSong:
      router.push(.fullSongPractice(state.selectedSong))
    }
  }
}

// MARK: - Preview

#Preview {
  BasePreview {
    LearningOptionsView(
      song: SongModel(
        id: "song_01",
        title: "여행을 떠나요",
        artist: "쿨",
        difficulty: .beginner,
        requiredCodes: [.A, .E, .B7],
        audioFileName: "forStudyGuitar",
        isUnlocked: true,
        isCompleted: false
      )
    )
  }
}
