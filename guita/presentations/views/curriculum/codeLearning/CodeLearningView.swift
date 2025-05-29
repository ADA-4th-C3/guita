//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 학습 목록을 표시하는 화면
/// 여러 난이도의 레슨들을 스크롤 가능한 목록으로 보여줌
struct CodeLearningListView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { CodeLearningListViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "학습 목록")
        
        // 메인 콘텐츠
        VStack(spacing: 0) {
          // 헤더 섹션
          headerSection
          
          // 레슨 목록
          lessonListSection(viewModel: viewModel, state: state)
        }
      }
      .background(Color.black)
      .onAppear {
        viewModel.loadLessons()
      }
    }
  }
  
  // MARK: - Header Section
  
  /// 상단 헤더 - 현재 선택된 곡 정보를 표시
  private var headerSection: some View {
    VStack(spacing: 16) {
      // 카테고리 제목
      Text("기타 기초 이론")
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // 현재 선택된 곡 카드
      currentSongCard
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
  }
  
  /// 현재 선택된 곡 정보 카드
  private var currentSongCard: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("[초급1] 여행을 떠나요")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
        
        // 코드 태그들
        HStack(spacing: 8) {
          ForEach(["A", "E", "B7"], id: \.self) { code in
            codeTag(code)
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
  
  // MARK: - Lesson List Section
  
  /// 레슨 목록 섹션
  private func lessonListSection(
    viewModel: CodeLearningListViewModel,
    state: CodeLearningListViewState
  ) -> some View {
    ScrollView {
      LazyVStack(spacing: 1) {
        ForEach(state.lessons) { lesson in
          LessonRowView(lesson: lesson) {
            handleLessonTap(lesson: lesson, viewModel: viewModel)
          }
        }
      }
    }
    .padding(.top, 20)
  }
  
  // MARK: - Private Methods
  
  /// 레슨 탭 처리
  private func handleLessonTap(lesson: LessonModel, viewModel: CodeLearningListViewModel) {
    guard lesson.isUnlocked else {
      Logger.d("잠금된 레슨 선택됨: \(lesson.title)")
      return
    }
    
    Logger.d("레슨 선택됨: \(lesson.title)")
    router.push(.codeDetail(lesson.codeType))
  }
}
