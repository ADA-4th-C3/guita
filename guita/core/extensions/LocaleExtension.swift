//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

extension Locale {
  /// 한국어 여부
  /// - 현재 영어와 한국어만 지원하므로 binary로 사용
  /// - LanguageCode만 보고 결정
  var isKo: Bool {
    let languageCode = identifier.split(whereSeparator: { $0 == "_" || $0 == "-" }).first!
    return languageCode == "ko"
  }

  /// Text To Speech 언어
  /// - ko-KR & en-US만 지원
  /// - Locale.current로 가져오면 en-KR 이런 케이스도 있는데, TTS 엔진에서 이상한 음성이 나와서 LanguageCode만 보고 ko-KR 또는 en-US로 통일
  var ttsLanguage: String {
    return isKo ? "ko-KR" : "en-US"
  }

  /// Speech To Test Locale
  /// - ko-KR & en-US만 지원
  var sttLocale: Locale {
    return Locale(identifier: isKo ? "ko-KR" : "en-US")
  }
}
