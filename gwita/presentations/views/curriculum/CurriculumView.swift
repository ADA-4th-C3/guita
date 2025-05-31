//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  var body: some View {
    BaseView(
      create: { CurriculumViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "학습 목록")
        Spacer()
        
        ScrollView {
          LazyVStack(alignment:.leading, spacing:8)
          {
            HStack {
              HStack {
                Text("[초급 1]")
                  .font(.system(size:18))
                  .fontWeight(.bold)
                Text("여행을 떠나요")
                  .font(.system(size:18))
                  .fontWeight(.bold)
              }.padding(.horizontal,30)
              Spacer()
              
              HStack {
                Text ("A")
                  .font(.system(size:17))
                  .foregroundColor(.black)
                  .padding(.horizontal,6)
                  .background(Color.white)
                  .cornerRadius(5)
                
                
                Text ("A")
                  .font(.system(size:17))
                  .padding(.horizontal,6)
                  .foregroundColor(.black)
                  .background(Color.white)
                  .cornerRadius(5)
                
                
                Text ("A")
                  .font(.system(size:17))
                  .foregroundColor(.black)
                  .padding(.horizontal,6)
                  .background(Color.white)
                  .cornerRadius(5)
              }
              .padding(.horizontal)
            }
            .frame(width:393, height:110)
            
            HStack {
              HStack {
                Text("[초급 1]")
                  .font(.system(size:18))
                  .fontWeight(.bold)
                Text("여행을 떠나요")
                  .font(.system(size:18))
                  .fontWeight(.bold)
              }.padding(.horizontal,30)
              Spacer()
              
              HStack {
                Text ("A")
                  .font(.system(size:17))
                  .foregroundColor(.black)
                  .padding(.horizontal,6)
                  .background(Color.white)
                  .cornerRadius(5)
                
                
                Text ("A")
                  .font(.system(size:17))
                  .padding(.horizontal,6)
                  .foregroundColor(.black)
                  .background(Color.white)
                  .cornerRadius(5)
                
                
                Text ("A")
                  .font(.system(size:17))
                  .foregroundColor(.black)
                  .padding(.horizontal,6)
                  .background(Color.white)
                  .cornerRadius(5)
              }
              .padding(.horizontal)
            }
            .frame(width:393, height:110)
            
            
          }
        }
      }
    } 
  }
}


#Preview {
  BasePreview {
    CurriculumView()
  }
}
