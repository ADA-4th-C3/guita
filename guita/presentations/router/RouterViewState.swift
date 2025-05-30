//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
}

enum SubPage: Hashable, Equatable {
  case curriculum
  case dev
  case pitchClassification
  case codeClassification
  case voiceControl
  
  // 기타 학습 관련 화면들
  case guitarLearning        // 기타 학습 메인
  case songList             // 노래 목록 (새로 추가)
  case learningOptions(SongModel)  // 학습 옵션 선택 (노래 정보 포함)
  
  // 코드 러닝
  case codeLearningList            // 코드 러닝 리스트
  case codeDetail(SongModel, CodeType)  // 코드 상세 학습
  case codeHelp(CodeType)    // 코드 도움말
  
  // 주법 학습
  case techniqueDetail(SongModel)       // 주법 학습
  case techniqueList
  case techniqueHelp         // 주법 도움말
  
  // 구간 학습
  case sectionPractice(SongModel)       // 곡 구간 학습
  case sectionPracticeHelp   // 곡 구간 학습 도움말
  
  // 곡 전체 학습
  case fullSongPractice(SongModel)      // 곡 전체 학습
  case fullSongPracticeHelp  // 곡 전체 학습 도움말
}

enum CodeType: String, CaseIterable {
  case a = "A"
  case b7 = "B7"
  case e = "E"
  case c = "C"
  case dm = "Dm"
  case em = "Em"
  case f = "F"
  case g = "G"
  case am = "Am"
  case bdim = "Bdim"
  case d = "D"
  
  var displayName: String {
    return rawValue + " 코드"
  }
}

struct RouterViewState {
  let rootPage: RootPage
  let subPages: [SubPage]
  
  func copy(
    rootPage: RootPage? = nil,
    subPages: [SubPage]? = nil
  ) -> RouterViewState {
    return RouterViewState(
      rootPage: rootPage ?? self.rootPage,
      subPages: subPages ?? self.subPages
    )
  }
}
