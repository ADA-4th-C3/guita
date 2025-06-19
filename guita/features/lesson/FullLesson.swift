//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum FullLesson {
  static func makeSteps() -> [FullLessonStep] {
    let steps = [
      FullLessonStep(
        song: "여행을 떠나요",
        step: 1,
        description: "곡 전체 학습",
        imageName: nil,
        fullLessonInfo: [FullLessonInfo(ttsText: nil)],
        audioFile: .basic_1,
        featureDescription: "다시 듣고 싶으시면 \"재생\"이라고 말씀해주십시오. 중간에 멈추고 싶으시면 \"정지\"라고 말씀해주십시오."
      ),
    ]
    return steps
  }
}
