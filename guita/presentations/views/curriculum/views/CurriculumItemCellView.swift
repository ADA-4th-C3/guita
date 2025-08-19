//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

struct CurriculumItemCell: View {
  let songInfo: SongInfo
  @EnvironmentObject var router: Router
  @Binding var selected: String?

  var body: some View {
    HStack(alignment: .center) {
      Text("[\(songInfo.level)] \(songInfo.truncatedTitle)")
        .fontKoddi(18, color: selected == songInfo.title ? .black : .light, weight: .bold)
        .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
        .padding(.leading, 25)

      Spacer()

      HStack {
        ForEach(songInfo.chords, id: \.self) { chord in
          Text("\(chord.rawValue)")
            .fontKoddi(17, color: selected == songInfo.title ? .light : .black, weight: .bold)
            .padding(.horizontal, 5.5)
            .padding(.vertical, 1)
            .background(selected == songInfo.title ? .black : .white)
            .cornerRadius(5)
        }
      }.padding(.trailing, 25)
    }
    .frame(height: 110)
    .contentShape(Rectangle())
    .onTapGesture {
      selected = songInfo.title
      router.push(.lesson(songInfo: songInfo))
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("\(songInfo.level) \(songInfo.title) 학습하기 버튼")
    .if(selected == songInfo.title) {
      v in v.background(.accent)
    }
  }
}
