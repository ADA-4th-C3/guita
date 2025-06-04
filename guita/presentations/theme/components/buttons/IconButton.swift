//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct IconButton: View {
  let icon: String
  let color: Color?
  let size: CGFloat?
  let padding: CGFloat?
  let disabled: Bool
  let isSystemImage: Bool
  let action: () -> Void

  var _color: Color {
    if disabled { return .darkGrey }
    return color ?? .light
  }

  init(
    _ icon: String,
    color: Color? = nil,
    size: CGFloat? = nil,
    padding: CGFloat? = nil,
    disabled: Bool = false,
    isSystemImage: Bool = false,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.color = color
    self.size = size
    self.padding = padding
    self.disabled = disabled
    self.isSystemImage = isSystemImage
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      let image: Image = isSystemImage
        ? Image(systemName: icon)
        : Image(icon)

      image
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .foregroundColor(_color)
        .padding(padding ?? (isSystemImage ? 20 : 16))
        .frame(width: size ?? 56, height: size ?? 56)
    }.opacity(disabled ? 0.5 : 1.0)
      .accessibilityRespondsToUserInteraction(!disabled)
  }
}

#Preview {
  BasePreview {
    ZStack {
      Color(.black)
      IconButton("chevron.right", isSystemImage: true) {}
    }
  }
}
