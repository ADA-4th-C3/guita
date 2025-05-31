//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 노래 목록에서 사용되는 개별 노래 행 컴포넌트
struct SongRowView: View {
  
  // MARK: - Properties
  
  let song: SongModel           // 표시할 노래 데이터
  let onTap: () -> Void        // 탭 액션 핸들러
  
  // MARK: - Body
  
  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        // 노래 정보 섹션
        songInfoSection
        
        Spacer()
        
        // 코드 태그 섹션
        codeTagsSection
        
        // 잠금/완료 상태 아이콘
        statusIcon
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(backgroundStyle)
      .disabled(!song.isUnlocked)
      .opacity(song.isUnlocked ? 1.0 : 0.5)
    }
    .buttonStyle(PlainButtonStyle())
    .overlay(bottomDivider, alignment: .bottom)
  }
  
  // MARK: - Private Views
  
  /// 노래 정보 섹션 (제목, 아티스트)
  private var songInfoSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(song.displayTitle)
        .font(.headline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("아티스트: \(song.artist)")
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  /// 코드 태그들 섹션
  private var codeTagsSection: some View {
    HStack(spacing: 6) {
      ForEach(song.requiredCodes, id: \.self) { code in
        codeTag(code.rawValue)
      }
    }
  }
  
  /// 개별 코드 태그
  private func codeTag(_ code: String) -> some View {
    Text(code)
      .font(.caption)
      .fontWeight(.medium)
      .foregroundColor(.black)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(Color.white)
      .cornerRadius(3)
  }
  
  /// 상태 아이콘 (잠금/완료)
  private var statusIcon: some View {
    Group {
      if !song.isUnlocked {
        Image(systemName: "lock.fill")
          .foregroundColor(.gray)
      } else if song.isCompleted {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      } else {
        Image(systemName: "chevron.right")
          .foregroundColor(.gray)
      }
    }
    .font(.system(size: 16))
  }
  
  /// 배경 스타일 (완료된 노래는 하이라이트)
  private var backgroundStyle: Color {
    song.isCompleted ? Color.yellow.opacity(0.1) : Color.clear
  }
  
  /// 하단 구분선
  private var bottomDivider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(.gray.opacity(0.2))
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 0) {
    SongRowView(
      song: SongModel(
        id: "1",
        title: "여행을 떠나요",
        artist: "조용필",
        difficulty: .beginner,
        requiredCodes: [.A, .E, .B7],
        audioFileName: "forStudyGuitar",
        isUnlocked: true,
        isCompleted: true
      )
    ) {
      print("노래 선택됨")
    }
    
    SongRowView(
      song: SongModel(
        id: "2",
        title: "바람이 불어오는 곳",
        artist: "이승환",
        difficulty: .beginner,
        requiredCodes: [.G, .C, .D],
        audioFileName: "song_02",
        isUnlocked: false,
        isCompleted: false
      )
    ) {
      print("잠금된 노래")
    }
  }
  .background(Color.black)
}
