//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

import SwiftUI

struct Toolbar<Leading: View, Trailing: View>: View {
  @EnvironmentObject var router: Router

  let title: String
  let subtitle: String?
  let titleColor: Color?
  let leading: () -> Leading
  let trailing: () -> Trailing
  let isPopButton: Bool

  init(
    title: String = "",
    titleColor: Color? = nil,
    subtitle: String? = nil,
    isPopButton: Bool = true,
    @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
    @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
  ) {
    self.title = title
    self.subtitle = subtitle
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
          IconButton("chevron.left") {
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
          .font(.koddiRegular24)
          .foregroundColor(.primary)
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
