//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonDetailView: View {
  let item : SongInfo
  @EnvironmentObject var router: Router
  
  var body: some View {
    
    BaseView(
      create: { LessonDetailViewModel(item: item) }
    ) { viewModel, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: item.level)
        Spacer()
        
        // MARK: SongTitle & Code
        VStack{
          VStack{
            Text(item.title)
              .fontWeight(.bold)
              .font(.system(size:32))
            Text(item.chords.joined(separator: ", "))
              .fontWeight(.semibold)
              .font(.system(size:20))
              .foregroundColor(.gray)
          }
          .frame(maxWidth: .infinity, maxHeight:220)
          
          // MARK: Learning Buttons
          GeometryReader { geometry in
            let boxWidth = geometry.size.width
            let boxHeight = geometry.size.height / 4
            
            LazyVStack(spacing: 0) {
              Button(action: {
                router.push(.curriculum) //임시로 라우팅 해둠
              }) {
                Text("코드 학습")
                  .font(.system(size:20))
                  .frame(width: boxWidth, height: boxHeight)
                  .background(Color.black)
                  .foregroundColor(.white)
                
              }
              Button(action: {
                router.push(.curriculum) //임시로 라우팅 해둠
              }) {
                Text("주법 학습")
                  .font(.system(size:20))
                  .frame(width: boxWidth, height: boxHeight)
                  .background(Color.black)
                  .foregroundColor(.white)
                
              }
              Button(action: {
                router.push(.curriculum) //임시로 라우팅 해둠
              }) {
                Text("곡 구간 학습")
                  .font(.system(size:20))
                  .frame(width: boxWidth, height: boxHeight)
                  .background(Color.black)
                  .foregroundColor(.white)
                
              }
              Button(action: {
                router.push(.curriculum) //임시로 라우팅 해둠
              }) {
                Text("곡 전체 학습")
                  .font(.system(size:20))
                  .frame(width: boxWidth, height: boxHeight)
                  .background(Color.black)
                  .foregroundColor(.white)
                
              }

            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    LessonDetailView(item: SongInfo(
      level: "[초급1]",
      title: "여행을 떠나요",
      chords: ["A", "B", "C"]
    ))
  }
}
