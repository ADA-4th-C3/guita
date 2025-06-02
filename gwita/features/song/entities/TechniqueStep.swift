//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TechniqueStep {
  let step: Int
  let totalSteps: Int
  let description: String
  let imageName: String?
  let effectName: String?
  let subSteps: [TechniqueSubStep]
}

struct TechniqueSubStep {
  let ttsText: String?
  let audioFile: AudioFile?
}
