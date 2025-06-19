//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevChordClassificationWithMLView: View {
  var body: some View {
    BaseView(
      create: { DevChordClassificationWithMLViewModel() }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.start()
          }
        }
      ) {
        VStack {
          Toolbar(title: "Code Classification with ML")
          Spacer()
          if state.isStarted {
            Text(state.isSilence ? "Silence" : "\(state.chord)")
              .fontKoddi(24, color: .accent)
            
            if let cgImage = cgImage(from: state.pixel!) {
              Image(decorative: cgImage, scale: 1.0)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
            }
          }
          Spacer()
        }
      }
    }
  }
  
  func cgImage(from pixelBuffer: CVPixelBuffer) -> CGImage? {
      let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
      let context = CIContext()
      return context.createCGImage(ciImage, from: ciImage.extent)
  }
}

#Preview {
  DevChordClassificationWithMLView()
}
