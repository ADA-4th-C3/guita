//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class CurriculumViewModel: BaseViewModel<[SongInfo]> {
  
  init() {
    super.init(state: CurriculumViewModel.guitarLessons())
  }
  
  static func guitarLessons() -> [SongInfo]{
    return [
      SongInfo(level: "[초급1]", title: "여행을 떠나요", chords: ["A", "E", "B7"]),
      SongInfo (level: "[초급2]", title: "바람이 불어오는 곳", chords: ["G", "C", "D"])
    ]
  }

}


