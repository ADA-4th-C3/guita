//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 기타 학습 메인 화면 - 곡 목록과 개발자 도구를 제공
struct GuitarLearningView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { GuitarLearningViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        customToolbar
        
        // 메인 콘텐츠
        VStack(spacing: 0) {
          // 개발자 도구 섹션 (상단 고정)
          developerToolsSection
          
          // 곡 목록 섹션
          songListSection(viewModel: viewModel, state: state)
        }
      }
      .background(Color.black)
      .onAppear {
        viewModel.loadSongs()
      }
    }
  }
  
  // MARK: - Custom Toolbar
  
  private var customToolbar: some View {
    HStack {
      Spacer()
      
      Text("기타 학습")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
      
      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
  }
  
  // MARK: - Developer Tools Section
  
  private var developerToolsSection: some View {
    VStack(spacing: 12) {
      // 개발자 도구 헤더
      HStack {
        Text("개발자 도구")
          .font(.caption)
          .foregroundColor(.gray)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      
      // 개발자 도구 버튼들
      HStack(spacing: 12) {
        Button("코드 학습") {
          router.push(.codeClassification)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(6)
        
        Button("Development") {
          router.push(.dev)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(6)
        
        Button("TTS 테스트") {
          Logger.d("TTS 테스트 버튼 클릭됨")
          
          let tts = TextToSpeech.shared  // 싱글톤 사용

                  
          tts.setSpeechStartHandler { text in
            Logger.d("✅ TTS 시작 성공: \(text)")
          }
          
          tts.setSpeechFinishHandler { text in
            Logger.d("✅ TTS 완료: \(text)")
          }
          
          tts.setSpeechErrorHandler { error in
            Logger.e("❌ TTS 오류: \(error)")
          }
          
          Logger.d("TTS speak 메서드 호출 시작")
          tts.speak(
            "나 줄리엔인데, 아 배고프다 편의점 갈 사람."
          )
          Logger.d("TTS speak 메서드 호출 완료")
        }
        
        Spacer()
      }
      .padding(.horizontal, 20)
      
      // 구분선
      Rectangle()
        .frame(height: 1)
        .foregroundColor(.gray.opacity(0.2))
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    .padding(.top, 16)
  }
  
  // MARK: - Song List Section
  
  private func songListSection(
    viewModel: GuitarLearningViewModel,
    state: GuitarLearningViewState
  ) -> some View {
    VStack(spacing: 0) {
      // 곡 목록 헤더
      HStack {
        Text("연습할 곡을 선택해주세요")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.white)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
      
      // 곡 목록
      ScrollView {
        // 기존 TTS 테스트 버튼 아래에 추가
        Button("A코드 학습 테스트") {
          let testSong = SongModel(
            id: "test_a_chord",
            title: "A코드 테스트",
            artist: "테스트",
            difficulty: .beginner,
            requiredCodes: [.A],
            audioFileName: "forStudyGuitar",
            isUnlocked: true,
            isCompleted: false
          )
          router.push(.codeDetail(testSong, .A))
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.green.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(6)
        
        Button("E코드 학습 테스트") {
          let testSong = SongModel(
            id: "test_e_chord",
            title: "E코드 테스트",
            artist: "테스트",
            difficulty: .beginner,
            requiredCodes: [.E],
            audioFileName: "forStudyGuitar",
            isUnlocked: true,
            isCompleted: false
          )
          router.push(.codeDetail(testSong, .E))
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(6)
        LazyVStack(spacing: 1) {
          ForEach(state.songs) { song in
            SongRowView(song: song) {
              handleSongTap(song: song)
            }
          }
        }
      }
      .padding(.top, 16)
    }
  }
  
  // MARK: - Private Methods
  
  private func handleSongTap(song: SongModel) {
    guard song.isUnlocked else {
      Logger.d("잠금된 곡 선택됨: \(song.title)")
      return
    }
    
    Logger.d("곡 선택됨: \(song.title)")
    router.push(.learningOptions(song))
  }
}
