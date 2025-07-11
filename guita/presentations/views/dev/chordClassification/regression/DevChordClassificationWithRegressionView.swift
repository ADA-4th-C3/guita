//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevChordClassificationWithRegressionView: View {
  var body: some View {
    BaseView(
      create: { DevChordClassificationWithRegressionViewModel() }
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
            Text(state.isSilence ? "Silence" : "\(state.chord.rawValue)")
              .fontKoddi(24, color: .accent)
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
  DevChordClassificationWithRegressionView()
}
