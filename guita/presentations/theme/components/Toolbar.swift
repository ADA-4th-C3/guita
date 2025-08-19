//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct Toolbar<Leading: View, FirstTrailing: View, SecondTrailing: View>: View {
  @EnvironmentObject var router: Router

  let titlePrefix: () -> AnyView
  let title: String
  let accessibilityLabel: String
  let accessibilityHint: String
  let titleColor: Color?
  let leading: () -> Leading
  let firstTrailing: () -> FirstTrailing
  let secondTrailing: () -> SecondTrailing
  let isPopButton: Bool
  let centerTitle: Bool
  @AccessibilityFocusState var initFocusToTitle: Bool

  init(
    @ViewBuilder titlePrefix: @escaping () -> some View = { EmptyView() },
    title: String = "",
    accessibilityLabel: String? = nil,
    accessibilityHint: String? = nil,
    titleColor: Color? = nil,
    isPopButton: Bool = true,
    centerTitle: Bool = false,
    @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
    @ViewBuilder firstTrailing: @escaping () -> FirstTrailing = { EmptyView() },
    @ViewBuilder secondTrailing: @escaping () -> SecondTrailing = {
      EmptyView()
    }
  ) {
    self.titlePrefix = { AnyView(titlePrefix()) }
    self.title = title
    self.accessibilityLabel = accessibilityLabel ?? title
    self.accessibilityHint = accessibilityHint ?? ""
    self.titleColor = titleColor
    self.leading = leading
    self.firstTrailing = firstTrailing
    self.secondTrailing = secondTrailing
    self.isPopButton = isPopButton
    self.centerTitle = centerTitle
  }

  var body: some View {
    // MARK: 중앙 정렬
    if centerTitle {
      ZStack {
        // Left/Right controls layer
        HStack {
          // Leading / Pop
          if isPopButton {
            IconButton("chevron.left", color: .light, isSystemImage: true) {
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
            .padding(.trailing, 5)
          } else {
            leading()
          }

          Spacer()

          // Trailing
          firstTrailing()
          secondTrailing()
        }

        // Centered title overlay
        if !title.isEmpty {
          HStack(spacing: 0) {
            titlePrefix()
            VStack {
//              Spacer()
              Text(title)
                .foregroundColor(.primary)
                .fontKoddi(32, weight: .bold)
                .lineSpacing(1.4)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .truncationMode(.tail)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(accessibilityLabel)
                .accessibilityAddTraits(.isHeader)
                .accessibilityHint(accessibilityHint)
                .accessibilityFocused($initFocusToTitle)
            }
          }
        }
      }
      .frame(height: 44)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          // initFocusToTitle = true
        }
      }
    } else {
      HStack(spacing: 0) {
        // MARK: Leading
        if isPopButton {
          IconButton("chevron.left", color: .light, isSystemImage: true) {
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
          .padding(.trailing, 5)
        } else {
          leading()
        }

        // MARK: Title
        if !title.isEmpty {
          HStack(spacing: 0) {
            titlePrefix()
            Text(title)
              .foregroundColor(.primary)
              .fontKoddi(32, weight: .bold)
              .lineSpacing(1.4)
              .lineLimit(1)
              .minimumScaleFactor(0.5)
              .truncationMode(.tail)
              .accessibilityElement(children: .ignore)
              .accessibilityLabel(accessibilityLabel)
              .accessibilityAddTraits(.isHeader)
              .accessibilityHint(accessibilityHint)
              .accessibilityFocused($initFocusToTitle)
          }
        }

        Spacer()

        // MARK: Trailing
        firstTrailing()
        secondTrailing()
      }
      .frame(width: .infinity, height: 44)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          // initFocusToTitle = true
        }
      }
      .padding(.bottom, 20)
    }
  }
}

#Preview {
  BasePreview {
    VStack {
      Toolbar(
        title: "Preview",
        firstTrailing: {
          IconButton("info") {
          }
        },
        secondTrailing: {
          IconButton("gearshape", isSystemImage: true) {
          }
        }
      )
      .border(.red)
      
      Toolbar(
        title: "Preview",
        centerTitle: true,
        firstTrailing: {
          IconButton("info") {
          }
        },
        secondTrailing: {
          IconButton("gearshape", isSystemImage: true) {
          }
        }
      )
      .border(.red)
    }
  }
}
