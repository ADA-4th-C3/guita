//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { TechniqueViewModel() }
    ) { viewModel, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title:"주법 학습")
        Spacer()
        
        VStack{
          Text("\(viewModel.state.currentStep.step)/\(viewModel.state.currentStep.totalSteps) 단계")
            .foregroundStyle(.gray)
            .font(.system(size:22))
            .padding(.vertical, 54)
            .offset(y: -70)
          VStack{
            Text(viewModel.state.currentStep.description)
              .foregroundStyle(.white)
              .fontWeight(.bold)
              .offset(y: -70)
              .foregroundStyle(.white)
              .font(.system(size:26))
              .padding(.horizontal, 30)
            
            
          }
        }
        .frame(width:393, height:550)
        .background(Color.black)
        
        
        Spacer()
        
        HStack{
          Button(action: {
            viewModel.previousStep()
          }) {
            Image("BackButton")
              .resizable()
              .frame(width:75, height:75)
              .padding(.horizontal, 42)
            
          }
          Button(action: {
          }) {
            Image("GuitarPlay")
              .resizable()
              .frame(width:95, height:95)
            
          }
          Button(action: {
            viewModel.nextStep()
          }) {
            Image("NextButton")
              .resizable()
              .frame(width:75, height:75)
              .padding(.horizontal, 42)
            
          }
        }
        .padding(.vertical,15)
        .background(Color.black)
      }
    }
  }
}

#Preview {
  BasePreview {
    TechniqueView()
  }
}
