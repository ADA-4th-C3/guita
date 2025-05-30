//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 주법 학습 목록을 표시하는 화면
struct TechniqueListView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { TechniqueListViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "주법 학습")
        
        // 메인 콘텐츠
        VStack(spacing: 0) {
          // 헤더 섹션
          headerSection
          
          // 주법 목록
          techniqueListSection(viewModel: viewModel, state: state)
        }
      }
      .background(Color.black)
      .onAppear {
        viewModel.loadTechniques()
      }
    }
  }
  
  // MARK: - Header Section
  
  /// 상단 헤더
  private var headerSection: some View {
    VStack(spacing: 16) {
      // 카테고리 제목
      Text("기타 연주 기법")
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
        Text("다양한 연주 기법을 배워보세요")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
        
        Text("스트러밍부터 핑거피킹까지")
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
  
  // MARK: - Technique List Section
  
  /// 주법 목록 섹션
  private func techniqueListSection(
    viewModel: TechniqueListViewModel,
    state: TechniqueListViewState
  ) -> some View {
    ScrollView {
      LazyVStack(spacing: 1) {
        ForEach(state.techniques) { technique in
          TechniqueRowView(technique: technique) {
            handleTechniqueTap(technique: technique)
          }
        }
      }
    }
    .padding(.top, 20)
  }
  
  // MARK: - Private Methods
  
  /// 주법 탭 처리
  private func handleTechniqueTap(technique: TechniqueModel) {
    guard technique.isUnlocked else {
      Logger.d("잠금된 주법 선택됨: \(technique.title)")
      return
    }
    
    Logger.d("주법 선택됨: \(technique.title)")
    // 임시 노래 객체로 주법 학습 시작
    let tempSong = SongModel(
      id: "temp_technique",
      title: technique.title,
      artist: "연습용",
      difficulty: .beginner,
      requiredCodes: [],
      audioFileName: "technique_practice",
      isUnlocked: true,
      isCompleted: false
    )
    router.push(.techniqueDetail(tempSong))
  }
}

/// 주법 목록에서 사용되는 개별 주법 행 컴포넌트
struct TechniqueRowView: View {
  
  let technique: TechniqueModel
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        // 주법 정보 섹션
        techniqueInfoSection
        
        Spacer()
        
        // 상태 아이콘
        statusIcon
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(backgroundStyle)
      .disabled(!technique.isUnlocked)
      .opacity(technique.isUnlocked ? 1.0 : 0.5)
    }
    .buttonStyle(PlainButtonStyle())
    .overlay(bottomDivider, alignment: .bottom)
  }
  
  // MARK: - Private Views
  
  /// 주법 정보 섹션
  private var techniqueInfoSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(technique.title)
        .font(.headline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(technique.description)
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  /// 상태 아이콘
  private var statusIcon: some View {
    Group {
      if !technique.isUnlocked {
        Image(systemName: "lock.fill")
          .foregroundColor(.gray)
      } else if technique.isCompleted {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      } else {
        Image(systemName: "chevron.right")
          .foregroundColor(.gray)
      }
    }
    .font(.system(size: 16))
  }
  
  /// 배경 스타일
  private var backgroundStyle: Color {
    technique.isCompleted ? Color.yellow.opacity(0.1) : Color.clear
  }
  
  /// 하단 구분선
  private var bottomDivider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(.gray.opacity(0.2))
  }
}

/// 주법 모델
struct TechniqueModel: Identifiable {
  let id: String
  let title: String
  let description: String
  let type: TechniqueType
  let isUnlocked: Bool
  let isCompleted: Bool
  let difficulty: TechniqueDifficulty
}

enum TechniqueDifficulty: String, CaseIterable {
  case beginner = "초급"
  case intermediate = "중급"
  case advanced = "고급"
}

/// 주법 학습 목록 뷰모델
final class TechniqueListViewModel: BaseViewModel<TechniqueListViewState> {
  
  init() {
    super.init(state: TechniqueListViewState())
  }
  
  func loadTechniques() {
    Logger.d("주법 목록 로딩 시작")
    
    let techniques = TechniqueDataFactory.createDefaultTechniques()
    
    emit(state.copy(
      techniques: techniques,
      isLoading: false
    ))
    
    Logger.d("주법 목록 로딩 완료: \(techniques.count)개")
  }
}

/// 주법 학습 목록 화면의 상태
struct TechniqueListViewState {
  let techniques: [TechniqueModel]
  let isLoading: Bool
  
  init(
    techniques: [TechniqueModel] = [],
    isLoading: Bool = true
  ) {
    self.techniques = techniques
    self.isLoading = isLoading
  }
  
  func copy(
    techniques: [TechniqueModel]? = nil,
    isLoading: Bool? = nil
  ) -> TechniqueListViewState {
    return TechniqueListViewState(
      techniques: techniques ?? self.techniques,
      isLoading: isLoading ?? self.isLoading
    )
  }
}

/// 주법 데이터 팩토리
struct TechniqueDataFactory {
  
  static func createDefaultTechniques() -> [TechniqueModel] {
    return [
      TechniqueModel(
        id: "technique_strumming",
        title: "스트러밍",
        description: "기본적인 코드 치기 기법",
        type: .strumming,
        isUnlocked: true,
        isCompleted: false,
        difficulty: .beginner
      ),
      TechniqueModel(
        id: "technique_fingerpicking",
        title: "핑거피킹",
        description: "손가락으로 줄을 개별적으로 뜯는 기법",
        type: .fingerpicking,
        isUnlocked: false,
        isCompleted: false,
        difficulty: .intermediate
      ),
      TechniqueModel(
        id: "technique_arpeggios",
        title: "아르페지오",
        description: "코드 음들을 순차적으로 연주하는 기법",
        type: .arpeggios,
        isUnlocked: false,
        isCompleted: false,
        difficulty: .intermediate
      ),
      TechniqueModel(
        id: "technique_palm_muting",
        title: "팜뮤팅",
        description: "손바닥으로 줄을 눌러 소리를 줄이는 기법",
        type: .palmMuting,
        isUnlocked: false,
        isCompleted: false,
        difficulty: .advanced
      )
    ]
  }
}
