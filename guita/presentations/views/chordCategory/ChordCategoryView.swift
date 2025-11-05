//  Copyright © 2025 ADA 4th Chor.

import SwiftUI

struct ChordCategoryView: View {
  @EnvironmentObject var router: Router

  @AccessibilityFocusState private var focusedChord: String?

  var body: some View {
    BaseView(
      create: {
        ChordCategoryViewModel()
      }
    ) { _, _ in
      ZStack {
        VStack(spacing: 0) {
          toolbar

          chordCategoryList

          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          focusedChord = nil
        }
      }
    }
  }

  private var toolbar: some View {
    Toolbar(
      title: "코드 카테고리",
      firstTrailing: {
        IconButton("info") {
          router.push(.chordLessonGuide)
        }.accessibilityAddTraits(.isButton)
          .accessibilityLabel("사용법 도움말")
          .accessibilityFocused($focusedChord, equals: "info")
      },
      secondTrailing: {
        IconButton("gearshape", isSystemImage: true) {
          router.push(.setting)
        }.accessibilityAddTraits(.isButton)
          .accessibilityHint("설정 화면으로 이동")
          .accessibilityFocused($focusedChord, equals: "setting")
      }
    )
  }

  private var chordCategoryList: some View {
    let rootChords: [Chord] = [.C, .D, .E, .F, .G, .A, .B]

    return ScrollView {
      VStack(spacing: 0) {
        ListDivider()

        ForEach(rootChords, id: \.self) { root in
          Button(action: {
            // TODO: - 루트별 코드 리스트로 routing
            router.push(.chordDetail(chord: root, chords: root.toChildren))
          }) {
            Text("\(root.rawValue) 코드")
              .fontKoddi(
                26,
                color: focusedChord == root.rawValue ? .black : .lightGrey,
                weight: .bold
              )
              .accessibilityAddTraits(.isButton)
              .accessibilityLabel("\(root.rawValue) 코드 학습하기")
              .frame(height: 110)
              .frame(maxWidth: .infinity)
              .background(focusedChord == root.rawValue ? Color.accent : Color.clear)
          }
          .accessibilityFocused($focusedChord, equals: root.rawValue)

          ListDivider()
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordCategoryView()
  }
}
