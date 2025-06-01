//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct VoiceCommandHistory: Identifiable {
  let id: UUID
  let keyword: VoiceCommandKeyword
  let rawText: String
  let phrase: String
  
  init(id: UUID = UUID(), keyword: VoiceCommandKeyword, rawText: String, phrase: String) {
    self.id = id
    self.keyword = keyword
    self.rawText = rawText
    self.phrase = phrase
  }
}

