//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

@main
struct Main: App {
  @StateObject var router = Router()
  
  var body: some Scene {
    WindowGroup {
      RouterView()
<<<<<<< HEAD
        .preferredColorScheme(.dark) //다크 모드
        .environment(\.font, .koddiRegular18) // KoddiUD 기본 폰트 설정
=======
        .modifier(FontKoddi(size: 16, weight: .regular))
>>>>>>> 8690b84b1301a3c2d88814b9f221dd051c749701
    }
    .environmentObject(router)
  }
}
