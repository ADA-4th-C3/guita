//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 학습 목록을 표시하는 화면
/// 여러 난이도의 코드 레슨들을 스크롤 가능한 목록으로 보여줌
struct ChordLearningListView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { ChordLearningListViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "코드 학습")
        
        // 메인 콘텐츠
        VStack(spacing: 0) {
          // 헤더 섹션
          headerSection
          
          // 코드 레슨 목록
          chordLessonListSection(viewModel: viewModel, state: state)
        }
      }
      .background(Color.black)
      .onAppear {
        viewModel.loadChordLessons()
      }
    }
  }
  
  // MARK: - Header Section
  
  /// 상단 헤더 - 코드 학습 소개
  private var headerSection: some View {
    VStack(spacing: 16) {
      // 카테고리 제목
      Text("기타 기초 코드")
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // 설명 카드
      descriptionCard
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
  }
  
  /// 설명 카드
  private var descriptionCard: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("기본 코드를 마스터하세요")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
        
        Text("손가락 위치와 프렛 정보 포함")
          .font(.caption)
          .foregroundColor(.black.opacity(0.7))
      }
      
      Spacer()
      
      Text("🎸")
        .font(.system(size: 32))
    }
    .padding(16)
    .background(Color.yellow)
    .cornerRadius(12)
  }
  
  // MARK: - Chord Lesson List Section
  
  /// 코드 레슨 목록 섹션
  private func chordLessonListSection(
    viewModel: ChordLearningListViewModel,
    state: ChordLearningListViewState
  ) -> some View {
    ScrollView {
      LazyVStack(spacing: 1) {
        ForEach(state.chordLessons) { chordLesson in
          ChordLessonRowView(chordLesson: chordLesson) {
            handleChordLessonTap(chordLesson: chordLesson, viewModel: viewModel)
          }
        }
      }
    }
    .padding(.top, 20)
  }
  
  // MARK: - Private Methods
  
  /// 코드 레슨 탭 처리
  private func handleChordLessonTap(chordLesson: ChordLessonModel, viewModel: ChordLearningListViewModel) {
    guard chordLesson.isUnlocked else {
      Logger.d("잠금된 코드 레슨 선택됨: \(chordLesson.title)")
      return
    }
    
    Logger.d("코드 레슨 선택됨: \(chordLesson.title)")
    
    // 기본 노래 모델 생성 (코드 학습용)
    let defaultSong = SongModel(
      id: chordLesson.id,
      title: chordLesson.title,
      artist: "코드 학습",
      difficulty: .beginner,
      requiredCodes: [chordLesson.chordType],
      audioFileName: "forStudyGuitar",
      isUnlocked: true,
      isCompleted: false
    )
    
    router.push(.codeDetail(defaultSong, chordLesson.chordType))
  }
}
