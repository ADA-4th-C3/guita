//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct SectionLessonStep {
  let song: String?
  let step: Int
  let description: String
  let imageName: String?
  let sectionLessonInfo: [SectionLessonInfo]
  let audioFile: AudioFile?
  let featureDescription: String
}

struct SectionLessonInfo {
  let ttsText: String?
  let chords: [Chord]
}
