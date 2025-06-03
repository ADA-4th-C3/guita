//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct GuideSection: View {
  let title: String
  let titleSize: CGFloat
  let contents: [String]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .fontKoddi(titleSize, color: .light, weight: .bold)
      
      Rectangle()
        .fill(Color.yellow)
        .frame(height: 2)
      
      ForEach(contents, id: \.self) { content in
        Text(content)
          .fontKoddi(18, color: .light)
          .lineSpacing(4)
      }
    }
  }
}
