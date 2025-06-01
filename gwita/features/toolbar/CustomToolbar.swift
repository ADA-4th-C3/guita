//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

struct CustomToolbar: View {
  var title: String
  var onBack: () -> Void
  var onInfo: (() -> Void)? = nil
  var showInfo: Bool = true
  
  var body: some View {
    HStack {
      Button(action: {onBack()}) {
        Image("arrow-trailing")
          .resizable()
          .frame(width: 24, height:24)
      }
      .padding(.leading, 16)
      
      Spacer()
      
      Text(title)
        .font(.custom("KoddiUDOnGothic-Bold",size: 24))
      
      Spacer()
      
      Group {
        if showInfo {
          Button(action: {
            onInfo?()
          }) {
            Image("info")
              .resizable()
              .frame(width: 24, height:24)
          }
        } else {
          Color.clear
            .frame(width: 24, height:24)
          
        }
      }
      .padding(.trailing, 16)
    }
    .frame(height: 44)
    
  }
}
