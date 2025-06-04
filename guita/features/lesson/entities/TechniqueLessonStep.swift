//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import Foundation

struct TechniqueLessonStep {
  let step: Int
  let totalSteps: Int
  let description: String
  let imageName: String?
  let subSteps: [TechniqueLessonSubStep]
  let featureDescription: String
}

struct TechniqueLessonSubStep {
  let ttsText: String?
  let audioFile: AudioFile?
  let delayAfter: TimeInterval?
  let speechRate: Float?
}
