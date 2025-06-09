//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum SectionLesson {
  static func makeSteps() -> [SectionLessonStep] {
    let steps = [
      SectionLessonStep(
        song: "여행을 떠나요",
        step: 1,
        description: "첫 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.A, .A, .E, .E])],
        audioFile: .section_repeat_1,
        featureDescription: "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를, 이전 학습으로 되돌아가시려면 \"이전\" 을 말씀해 주세요."
      ),
      SectionLessonStep(
        song: nil,
        step: 2,
        description: "두 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.B7, .B7, .E, .E])],
        audioFile: .section_repeat_2,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 3,
        description: "세 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.E, .E, .E, .E])],
        audioFile: .section_repeat_3,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 4,
        description: "네 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.A, .A, .E, .E])],
        audioFile: .section_repeat_4,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 5,
        description: "다섯 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.B7, .B7, .E, .E])],
        audioFile: .section_repeat_5,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 6,
        description: "여섯 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.E, .E, .E, .E])],
        audioFile: .section_repeat_6,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 7,
        description: "일곱 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.A, .A, .E, .E])],
        audioFile: .section_repeat_7,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 8,
        description: "여덟 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.B7, .B7, .E, .E])],
        audioFile: .section_repeat_8,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 9,
        description: "아홉 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.A, .A, .E, .E])],
        audioFile: .section_repeat_9,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 10,
        description: "열 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.B7, .B7, .E, .E])],
        audioFile: .section_repeat_10,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 11,
        description: "열한 번째 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.A, .A, .E, .E])],
        audioFile: .section_repeat_11,
        featureDescription: ""
      ),
      SectionLessonStep(
        song: nil,
        step: 12,
        description: "마지막 구간 연습",
        imageName: nil,
        sectionLessonInfo: [SectionLessonInfo(ttsText: nil, chords: [.B7, .B7, .E, .E])],
        audioFile: .section_repeat_12,
        featureDescription: ""
      ),
    ]
    return steps
  }
}
