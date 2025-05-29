//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct CodeClassificationViewState {
  let recordPermissionState: PermissionState //녹음 권한
  let code: String // 화면상에 나올 코드 !
  let confidence: Float
  let allMatches: [(code: String, confidence: Float)]
  
  
  func copy(
    recordPermissionState: PermissionState? = nil,
    code: String? = nil,
    confidence: Float? = nil,
    allMatches: [(code: String, confidence: Float)]? = nil
  ) -> CodeClassificationViewState {
    return CodeClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      code: code ?? self.code,
      confidence: confidence ?? self.confidence,
      allMatches: allMatches ?? self.allMatches
    )
  }
}
