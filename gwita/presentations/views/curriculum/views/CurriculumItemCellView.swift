//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

struct CurriculumItemCell: View {
  let item: SongInfo
  @EnvironmentObject var router: Router

  var body: some View {
    HStack {
      HStack {
        Text(item.level)
          .font(.system(size: 18))
          .fontWeight(.bold)
        Text(item.title)
          .font(.system(size: 18))
          .fontWeight(.bold)
      }
      .padding(.horizontal, 30)

      Spacer()

      HStack {
        ForEach(item.chords, id: \.self) { chord in
          Text("\(chord.rawValue)")
            .font(.system(size: 17))
            .foregroundColor(.black)
            .padding(.horizontal, 6)
            .background(Color.white)
            .cornerRadius(5)
        }
      }
      .padding(.horizontal)
      .frame(height: 110)
      // padding 영역 조절하기
    }
    .contentShape(Rectangle())
    .onTapGesture {
      router.push(.lesson(item: item))
    }
  }
}
