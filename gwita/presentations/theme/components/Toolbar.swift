//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

import SwiftUI

struct Toolbar<Leading: View, Trailing: View>: View {
  @EnvironmentObject var router: Router

  let title: String
  let titleColor: Color?
  let leading: () -> Leading
  let trailing: () -> Trailing
  let isPopButton: Bool

  init(
    title: String = "",
    titleColor: Color? = nil,
    isPopButton: Bool = true,
    @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
    @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
  ) {
    self.title = title
    self.titleColor = titleColor
    self.leading = leading
    self.trailing = trailing
    self.isPopButton = isPopButton
  }

  var body: some View {
    ZStack {
      HStack {
        // MARK: Leading
        if isPopButton {
          IconButton("arrow-leading", color: .light, isSystemImage: false) {
            router.pop()
          }
        } else {
          leading()
        }

        Spacer()

        // MARK: Trailing
        trailing()
      }

      // MARK: Title
      if !title.isEmpty {
        Text(title)
          .foregroundColor(.primary)
          .fontKoddi(24, weight: .bold)
          .lineSpacing(1.4)
      }
    }
    .frame(height: 56)
  }
}

#Preview {
  BasePreview {
    Toolbar(
      title: "Preview",
      isPopButton: true,
      trailing: {
        IconButton("pencil") {}
      }
    )
  }
}
