//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 주법 학습 상세 화면
/// 다양한 기타 연주 기법을 학습하는 화면
struct TechniqueDetailView: View {
  
  // MARK: - Properties
  
  let song: SongModel
  @EnvironmentObject var router: Router
  @State private var showingPermissionFlow = false
  
  // MARK: - Body
  
  var body: some View {
    BaseView(
      create: {
        TechniqueDetailViewModel.create(song: song)
      },
      needsPermissions: true
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 커스텀 툴바
        Toolbar(
          title: "주법 학습",
          subtitle: song.displayTitle,
          trailing: {
            IconButton("info.circle") {
              router.push(.techniqueHelp)
            }
          }
        )
        
        // 메인 콘텐츠
        mainContent(viewModel: viewModel, state: state)
      }
      .background(Color.black)
      .onAppear(){
        viewModel.startLearning()
      }
      .onDisappear {
        viewModel.stopLearning()
      }
      
    }
  }
  
  
  // MARK: - Main Content
  
  /// 메인 콘텐츠 섹션
  private func mainContent(
    viewModel: TechniqueDetailViewModel,
    state: TechniqueDetailViewState
  ) -> some View {
    VStack(spacing: 40) {
      Spacer()
      
      // 단계 표시
      stepIndicator(state: state)
      
      // 단계별 콘텐츠
      stepContent(viewModel: viewModel, state: state)
      
      Spacer()
      
      // 하단 네비게이션
      bottomNavigation(viewModel: viewModel, state: state)
    }
    .padding(.horizontal, 20)
  }
  
  // MARK: - Step Indicator
  
  /// 현재 단계를 표시하는 인디케이터
  private func stepIndicator(state: TechniqueDetailViewState) -> some View {
    Text("\(state.currentStep)/\(state.totalSteps) 단계")
      .font(.caption)
      .foregroundColor(.gray)
  }
  
  // MARK: - Step Content
  
  /// 현재 단계에 맞는 콘텐츠를 표시
  private func stepContent(
    viewModel: TechniqueDetailViewModel,
    state: TechniqueDetailViewState
  ) -> some View {
    VStack(spacing: 24) {
      if state.currentStep == state.totalSteps {
        // 완료 단계
        TechniqueCompletionView()
      } else {
        // 일반 학습 단계
        TechniqueLearningContentView(
          instruction: state.currentInstruction,
          techniqueType: state.currentTechnique
        )
      }
    }
  }
  
  // MARK: - Bottom Navigation
  
  /// 하단 네비게이션 (이전/다음 버튼, 음성 시각화)
  private func bottomNavigation(
    viewModel: TechniqueDetailViewModel,
    state: TechniqueDetailViewState
  ) -> some View {
    HStack(spacing: 0) {
      // 이전 버튼
      navigationButton(
        iconName: "chevron.left",
        isEnabled: state.currentStep > 1,
        action: { viewModel.previousStep() }
      )
      
      Spacer()
      
      // 음성 시각화 및 인식된 정보 표시
      AudioVisualizationView(
        isListening: state.isListening,
        recognizedCode: state.recognizedInput
      )
      
      Spacer()
      
      // 다음 버튼
      navigationButton(
        iconName: "chevron.right",
        isEnabled: state.canProceed,
        action: { viewModel.nextStep() }
      )
    }
    .padding(.horizontal, 40)
    .padding(.bottom, 40)
  }
  
  // MARK: - Navigation Button
  
  /// 네비게이션 버튼 (이전/다음)
  private func navigationButton(
    iconName: String,
    isEnabled: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: iconName)
        .font(.title)
        .foregroundColor(isEnabled ? .white : .gray)
    }
    .disabled(!isEnabled)
    .opacity(isEnabled ? 1.0 : 0.3)
  }
  
}

/// 주법 학습 콘텐츠를 표시하는 컴포넌트
struct TechniqueLearningContentView: View {
  
  let instruction: String
  let techniqueType: TechniqueType
  
  var body: some View {
    VStack(spacing: 24) {
      // 안내 문구
      Text(instruction)
        .font(.title2)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .lineSpacing(4)
        .fixedSize(horizontal: false, vertical: true)
      
      // 시각적 힌트
      VStack(spacing: 12) {
        Text("연습할 주법")
          .font(.caption)
          .foregroundColor(.gray)
        
        Text(techniqueType.displayName)
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.yellow)
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
          )
      }
      .padding(.top, 16)
    }
  }
}

/// 주법 학습 완료를 표시하는 컴포넌트
struct TechniqueCompletionView: View {
  
  var body: some View {
    VStack(spacing: 24) {
      // 완료 이모지
      Text("🎸")
        .font(.system(size: 60))
      
      // 완료 메시지
      Text("주법 학습이\n완료되었습니다.")
        .font(.title2)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .lineSpacing(4)
      
      // 성취 표시
      VStack(spacing: 8) {
        Text("완료!")
          .font(.headline)
          .fontWeight(.bold)
          .foregroundColor(.black)
        
        Text("기타 주법 마스터")
          .font(.caption)
          .foregroundColor(.black.opacity(0.7))
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(Color.yellow)
      .cornerRadius(12)
    }
  }
}

enum TechniqueType: String, CaseIterable {
  case strumming = "스트러밍"
  case fingerpicking = "핑거피킹"
  case arpeggios = "아르페지오"
  case palmMuting = "팜뮤팅"
  
  var displayName: String {
    return rawValue
  }
}
