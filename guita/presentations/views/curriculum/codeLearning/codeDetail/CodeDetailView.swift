//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 개별 코드의 상세 학습 화면
/// 단계별로 코드 학습을 진행하며 실시간 코드 인식 기능을 제공
struct CodeDetailView: View {
  
  // MARK: - Properties
  
  let codeType: CodeType
  @EnvironmentObject var router: Router
  
  // MARK: - Body
  
  var body: some View {
    BaseView(
      create: { CodeDetailViewModel(codeType: codeType) }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 커스텀 툴바
        customToolbar
        
        // 메인 콘텐츠
        mainContent(viewModel: viewModel, state: state)
      }
      .background(Color.black)
      .onAppear {
        viewModel.startLearning()
      }
      .onDisappear {
        viewModel.stopLearning()
      }
    }
  }
  
  // MARK: - Custom Toolbar
  
  /// 뒤로가기 버튼과 도움말 버튼이 있는 커스텀 툴바
  private var customToolbar: some View {
    HStack {
      IconButton("chevron.left") {
        router.pop()
      }
      
      Spacer()
      
      Text(codeType.displayName)
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
      
      Spacer()
      
      IconButton("info.circle") {
        router.push(.codeHelp(codeType))
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
  }
  
  // MARK: - Main Content
  
  /// 메인 콘텐츠 섹션
  private func mainContent(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
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
  private func stepIndicator(state: CodeDetailViewState) -> some View {
    Text("\(state.currentStep)/\(state.totalSteps) 단계")
      .font(.caption)
      .foregroundColor(.gray)
  }
  
  // MARK: - Step Content
  
  /// 현재 단계에 맞는 콘텐츠를 표시
  private func stepContent(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
  ) -> some View {
    VStack(spacing: 24) {
      if state.currentStep <= 2 {
        // 권한 요청 단계
        PermissionRequestView(
          step: state.currentStep,
          codeType: codeType
        ) {
          viewModel.handlePermissionGranted()
        }
      } else if state.currentStep == state.totalSteps {
        // 완료 단계
        CompletionView(codeType: codeType)
      } else {
        // 일반 학습 단계
        LearningContentView(
          instruction: state.currentInstruction,
          codeType: codeType
        )
      }
    }
  }
  
  // MARK: - Bottom Navigation
  
  /// 하단 네비게이션 (이전/다음 버튼, 음성 시각화)
  private func bottomNavigation(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
  ) -> some View {
    HStack(spacing: 0) {
      // 이전 버튼
      navigationButton(
        iconName: "chevron.left",
        isEnabled: state.currentStep > 1,
        action: { viewModel.previousStep() }
      )
      
      Spacer()
      
      // 음성 시각화 및 인식된 코드 표시
      AudioVisualizationView(
        isListening: state.isListening,
        recognizedCode: state.recognizedCode
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
