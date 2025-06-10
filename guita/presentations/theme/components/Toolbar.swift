//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

import SwiftUI

struct Toolbar<Leading: View, Trailing: View>: View {
  @EnvironmentObject var router: Router
  
  let title: String
  let accessibilityLabel: String
  let accessibilityHint: String
  let titleColor: Color?
  let leading: () -> Leading
  let trailing: () -> Trailing
  let isPopButton: Bool
  
  init(
    title: String = "",
    accessibilityLabel: String? = nil,
    accessibilityHint: String? = nil,
    titleColor: Color? = nil,
    isPopButton: Bool = true,
    @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
    @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
  ) {
    self.title = title
    self.accessibilityLabel = accessibilityLabel ?? title
    self.accessibilityHint = accessibilityHint ?? ""
    self.titleColor = titleColor
    self.leading = leading
    self.trailing = trailing
    self.isPopButton = isPopButton
  }
  
  var body: some View {
//    Logger.d(router.previousTitle)
    return ZStack {
      HStack {
        // MARK: Leading
        if isPopButton {
          IconButton("arrow-left", color: .light, isSystemImage: false) {
            router.pop()
          }
          .accessibilityLabel("나가기")
          .accessibilityAddTraits(.isButton)
          .accessibilityHint(
            String(
              format: NSLocalizedString("ExitButton.Desc", comment: ""),
              router.previousTitle
            )
          )
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
          .accessibilityElement(children: .ignore)
          .accessibilityLabel(accessibilityLabel)
          .accessibilityAddTraits(.isHeader)
          .accessibilityHint(accessibilityHint)
      }
    }
    .frame(height: 44)
  }
}

#Preview {
  BasePreview {
    Toolbar(
      title: "Preview",
      isPopButton: true,
      trailing: {
        IconButton("pencil", isSystemImage: true) {}
      }
    )
  }
}
