//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

enum Koddi: String {
  case regular = "KoddiUDOnGothic-Regular"
  case bold = "KoddiUDOnGothic-Bold"
  case extraBold = "KoddiUDOnGothic-ExtraBold"
}

struct FontKoddi: ViewModifier {
    var size: CGFloat
    var color: Color?
    var weight: Koddi

    func body(content: Content) -> some View {
        content
            .font(.custom(weight.rawValue, size: size))
            .foregroundColor(color)
    }
}

extension View {
    func fontKoddi(_ size: CGFloat, color: Color? = nil, weight: Koddi = .regular) -> some View {
        self.modifier(FontKoddi(size: size, color: color, weight: weight))
    }
}
