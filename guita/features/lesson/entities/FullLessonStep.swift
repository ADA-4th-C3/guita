//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct FullLessonStep {
  let song: String?
  let step: Int
  let description: String
  let imageName: String?
  let fullLessonInfo : [FullLessonInfo]
  let audioFile: AudioFile?
  let featureDescription: String
}

struct FullLessonInfo {
  let ttsText: String?
}

