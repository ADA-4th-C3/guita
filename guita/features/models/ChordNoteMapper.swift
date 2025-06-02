//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// Chord와 Note 사이의 매핑을 제공하는 유틸리티 클래스
struct ChordNoteMapper {
  
  /// 특정 코드의 특정 줄에서 연주해야 하는 노트를 반환한다
  /// - Parameters:
  ///   - chord: 대상 코드 (예: .A)
  ///   - string: 기타 줄 번호 (1~6, 1이 가장 높은 줄)
  /// - Returns: 해당 줄에서 연주해야 하는 Note, 해당 줄을 사용하지 않으면 nil
  static func getExpectedNote(for chord: Chord, string: Int) -> Note? {
    // 코드의 coordinates에서 해당 줄의 프렛 정보 찾기
    let coordinates = chord.coordinates
    
    for (positions, _) in coordinates {
      for position in positions {
        if position.string == string {
          // 해당 줄의 프렛을 찾았으므로 Note 계산
          return calculateNote(string: string, fret: position.fret)
        }
      }
    }
    
    // 코드에서 해당 줄을 사용하지 않는 경우
    // 개방현인지 확인 (일부 코드는 특정 줄을 개방현으로 사용)
    if isOpenString(for: chord, string: string) {
      return calculateNote(string: string, fret: 0)
    }
    
    return nil
  }
  
  /// 특정 코드에서 사용하는 모든 노트들을 반환한다
  /// - Parameter chord: 대상 코드
  /// - Returns: (줄번호, 노트) 쌍의 배열
  static func getAllNotesForChord(_ chord: Chord) -> [(string: Int, note: Note)] {
    var result: [(string: Int, note: Note)] = []
    
    // 1번줄부터 6번줄까지 확인
    for string in 1...6 {
      if let note = getExpectedNote(for: chord, string: string) {
        result.append((string: string, note: note))
      }
    }
    
    return result
  }
  
  /// 인식된 노트가 특정 코드의 특정 줄에서 올바른 노트인지 검증한다
  /// - Parameters:
  ///   - recognizedNote: 인식된 노트명 (예: "F#2/Gb2")
  ///   - chord: 대상 코드
  ///   - string: 기타 줄 번호
  /// - Returns: 올바른 노트인지 여부
  static func validateNote(_ recognizedNote: String, for chord: Chord, string: Int) -> Bool {
    guard let expectedNote = getExpectedNote(for: chord, string: string) else {
      return false
    }
    
    // 인식된 노트가 예상 노트와 일치하는지 확인
    return isNotesMatching(recognizedNote: recognizedNote, expectedNote: expectedNote)
  }
  
  /// 특정 코드에서 해당 줄이 개방현으로 사용되는지 확인한다
  /// - Parameters:
  ///   - chord: 대상 코드
  ///   - string: 기타 줄 번호
  /// - Returns: 개방현 사용 여부
  private static func isOpenString(for chord: Chord, string: Int) -> Bool {
    // 코드별 개방현 사용 패턴 (예시)
    switch chord {
    case .A:
      // A코드: 1, 5, 6번줄은 개방현 사용
      return [1, 5, 6].contains(string)
    case .E:
      // E코드: 1, 2, 3, 6번줄은 개방현 사용
      return [1, 2, 3, 6].contains(string)
    case .B7:
      // B7코드: 2, 6번줄은 개방현 사용
      return [2, 6].contains(string)
    default:
      // 다른 코드들은 추후 구현
      return false
    }
  }
  
  /// 기타 줄과 프렛 번호로부터 해당하는 Note를 계산한다
  /// - Parameters:
  ///   - string: 기타 줄 번호 (1~6)
  ///   - fret: 프렛 번호 (0은 개방현)
  /// - Returns: 해당하는 Note
  private static func calculateNote(string: Int, fret: Int) -> Note? {
    // 각 줄의 개방현 노트
    let openStringNotes: [Int: Note] = [
      1: .E4,  // 1번줄 (가장 높은 음)
      2: .B3,  // 2번줄
      3: .G3,  // 3번줄
      4: .D3,  // 4번줄
      5: .A2,  // 5번줄
      6: .E2   // 6번줄 (가장 낮은 음)
    ]
    
    guard let openNote = openStringNotes[string] else { return nil }
    
    // 프렛만큼 반음 올려서 계산
    let allNotes = Note.allCases
    guard let openIndex = allNotes.firstIndex(of: openNote) else { return nil }
    
    let targetIndex = openIndex + fret
    guard targetIndex < allNotes.count else { return nil }
    
    return allNotes[targetIndex]
  }
  
  /// 인식된 노트와 예상 노트가 일치하는지 확인한다
  /// - Parameters:
  ///   - recognizedNote: 인식된 노트명 (예: "F#2/Gb2")
  ///   - expectedNote: 예상 노트
  /// - Returns: 일치 여부
  private static func isNotesMatching(recognizedNote: String, expectedNote: Note) -> Bool {
    // 예상 노트의 주파수
    let expectedFrequency = expectedNote.frequency
    
    // 인식된 노트에서 주파수 정보 추출
    // Note.allCases에서 인식된 노트명과 일치하는 것을 찾아 주파수 비교
    for note in Note.allCases {
      let noteString = String(describing: note)
      if recognizedNote.contains(noteString) ||
         recognizedNote.contains(noteString.replacingOccurrences(of: "b", with: "#")) {
        
        // 주파수 허용 오차 범위 (±15Hz)
        let tolerance: Double = 15.0
        return abs(note.frequency - expectedFrequency) <= tolerance
      }
    }
    
    return false
  }
  
  /// 디버깅용: 특정 코드의 모든 줄-노트 매핑을 출력한다
  static func printChordMapping(_ chord: Chord) {
    print("=== \(chord.rawValue) 코드 매핑 ===")
    
    for string in 1...6 {
      if let note = getExpectedNote(for: chord, string: string) {
        print("\(string)번줄: \(note) (\(note.frequency)Hz)")
      } else {
        print("\(string)번줄: 사용하지 않음")
      }
    }
    
    print("========================")
  }
}

// MARK: - 사용 예시 및 테스트용 확장

extension ChordNoteMapper {
  
  /// A코드 학습에서 사용할 줄별 노트 정보를 반환한다
  static func getAChordLearningNotes() -> [Int: Note] {
    var notes: [Int: Note] = [:]
    
    // A코드에서 실제 사용하는 줄들만
    for string in [2, 3, 4] {  // A코드는 2,3,4번줄에 손가락 사용
      if let note = getExpectedNote(for: .A, string: string) {
        notes[string] = note
      }
    }
    
    return notes
  }
  
  /// E코드 학습에서 사용할 줄별 노트 정보를 반환한다
  static func getEChordLearningNotes() -> [Int: Note] {
    var notes: [Int: Note] = [:]
    
    // E코드에서 실제 사용하는 줄들만
    for string in [4, 5] {  // E코드는 4,5번줄에 손가락 사용
      if let note = getExpectedNote(for: .E, string: string) {
        notes[string] = note
      }
    }
    
    return notes
  }
}
