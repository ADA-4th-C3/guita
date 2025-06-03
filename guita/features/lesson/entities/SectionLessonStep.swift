//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct SectionLessonStep {
  let step: Int
  let totalSteps: Int
  let description: String
  let imageName: String?
  let sectionLessonInfo: [SectionLessonInfo]
  let featureDescription: String
}

struct SectionLessonInfo {
  let ttsText: String?
  let audioFile: AudioFile?
}
