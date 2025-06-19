//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

// MARK: - 사용 예시
/*

 // 기본 사용법
 "play_button".localized()

 // 주석과 함께 사용
 "play_button".localized(comment: "재생 버튼 텍스트")

 // 포맷 인수와 함께 사용
 "remaining_time".localized("%d분 %d초 남음", 3, 27)

 // VoiceOver 접근성에서 사용
 .accessibilityLabel("play_button_voice".localizedhoe())
 .accessibilityHint("voice_control_hint".localized())

 // SwiftUI Text에서 사용
 Text("current_status".localized())

 // 특정 테이블에서 사용
 "error_message".localized(tableName: "Errors", comment: "에러 메시지")

 */

extension String {
  /// 현재 문자열을 현지화된 문자열로 반환한다
  /// - Parameter comment: 번역자를 위한 주석
  /// - Returns: 현지화된 문자열
  func localized(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }

  /// 현재 문자열을 현지화하고 포맷 인수를 적용한다
  /// - Parameters:
  ///   - comment: 번역자를 위한 주석
  ///   - args: 포맷에 사용할 인수들
  /// - Returns: 포맷이 적용된 현지화 문자열
  func localized(comment: String = "", _ args: CVarArg...) -> String {
    let localizedString = NSLocalizedString(self, comment: comment)
    return String(format: localizedString, arguments: args)
  }

  /// 특정 테이블에서 현지화된 문자열을 반환한다
  /// - Parameters:
  ///   - tableName: 문자열 테이블 이름
  ///   - comment: 번역자를 위한 주석
  /// - Returns: 현지화된 문자열
  func localized(tableName: String?, comment: String = "") -> String {
    return NSLocalizedString(self, tableName: tableName, comment: comment)
  }
}
