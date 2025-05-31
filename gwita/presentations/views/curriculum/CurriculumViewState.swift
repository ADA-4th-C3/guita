//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct CurriculumViewState :Identifiable {
  let id = UUID()
  let level: String
  let title: String
  let chords: [String]
  let isSelected :Bool
  
  func copy(level: String? = nil,title: String? = nil,chords: [String]? = nil,isSelected: Bool? = nil) -> CurriculumViewState {
    return CurriculumViewState(
      level: level ?? self.level,
      title: title ?? self.title,
      chords: chords ?? self.chords,
      isSelected: isSelected ?? self.isSelected
    )
  }
}
