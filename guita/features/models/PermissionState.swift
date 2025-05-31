//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum PermissionState {
  case undetermined
  case denied
  case granted
}

enum PermissionFlowStep {
  case introduction     // 권한 안내
  case microphoneRequest // 마이크 권한 요청
  case speechRequest    // 음성인식 권한 요청
  case completed        // 완료
}
