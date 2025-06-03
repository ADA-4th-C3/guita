//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordProgressionBar: View {
  let chords: [Chord]
  
  var body: some View {
    VStack(spacing: 8) {
      // 박자 표시 (4/4박자 가정)
      HStack {
        
        VStack(spacing: 0) {
          Text("4")
            .fontKoddi(14)
            .foregroundColor(.gray)
          Divider()
            .background(Color.gray)
            .frame(width: 15, height: 4)  // Text 폭의 80%
          Text("4")
            .fontKoddi(14)
            .foregroundColor(.gray)
        }
        .padding(.bottom, -10)
        Spacer()
      }
      
      
      // 코드 이름 표시
      HStack(spacing: 0) {
        ForEach(0..<chords.count, id: \.self) { index in
          VStack(spacing: 0) {
            // 코드 이름 (위)
            Text(chords[index].rawValue)
              .font(.system(size: 24, weight: .bold))
              .padding(.leading, 3)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            
            // 가로 Rectangle과 세로 구분선 (아래)
            HStack(spacing: 0) {
              
              Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 20)
              
              Rectangle()
                .frame(height: 4)
              
              if index == chords.count - 1 {
                Rectangle()
                  .fill(Color.white)
                  .frame(width: 1, height: 20)
              }
            }
          }
        }
      }
      
      
    }
    .padding()
    .background(Color.black)
    .cornerRadius(8)
  }
}


#Preview
{
  ChordProgressionBar(chords: [.A, .E, .B7, .E])
}
