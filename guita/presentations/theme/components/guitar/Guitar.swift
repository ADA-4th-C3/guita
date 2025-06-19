//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

enum NoteOrChord {
  case note(Note)
  case chord(Chord)

  var coordinates: [(string: Int, fret: Int, finger: Int?)] {
    switch self {
    case let .note(note):
      return note.coordinates.map { (string: $0.string, fret: $0.fret, finger: nil) }
    case let .chord(chord):
      return chord.coordinates.flatMap { group in
        group.0.map { (string: $0.string, fret: $0.fret, finger: group.finger) }
      }
    }
  }

  var label: String {
    switch self {
    case let .note(note):
      return "\(note)"
    case .chord:
      return ""
    }
  }
}

struct Guitar: View {
  var input: NoteOrChord?
  var body: some View {
    GeometryReader { geometry in
      let stringCount = 6
      let fretCount = 20
      let openFretOffset: CGFloat = 1.0
      let notePositions = input?.coordinates ?? []
      let markerFrets: Set<Int> = [3, 5, 7, 9, 12, 15, 17]

      let width = geometry.size.width
      let height = geometry.size.height
      let fretSpacing = height / CGFloat(fretCount + Int(openFretOffset))
      let stringSpacing = width / CGFloat(stringCount + 1)

      ZStack {
        // Draw strings
        ForEach(1 ... stringCount, id: \.self) { string in
          let x = CGFloat(string) * stringSpacing
          Path { path in
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
          }
          .stroke(lineWidth: CGFloat(7 - string))
          .foregroundStyle(.darkGrey)
        }

        // Draw frets
        ForEach(1 ... fretCount, id: \.self) { fret in
          let y = CGFloat(fret) * fretSpacing + (openFretOffset * fretSpacing)
          Path { path in
            path.move(to: CGPoint(x: fretSpacing, y: y))
            path.addLine(to: CGPoint(x: width - fretSpacing, y: y))
          }
          .stroke(lineWidth: 1)
        }

        // Draw fret markers
        ForEach(markerFrets.sorted(), id: \.self) { fret in
          let y = (CGFloat(fret) + openFretOffset + 0.5) * fretSpacing
          Circle()
            .fill(.darkGrey.opacity(0.75))
            .frame(width: 10, height: 10)
            .position(x: width / 2, y: y)
        }

        // Draw note/chord positions
        ForEach(Array(notePositions.enumerated()), id: \.offset) { _, position in
          let x = width - (CGFloat(position.string) * stringSpacing)
          let y = (CGFloat(position.fret) + openFretOffset) * fretSpacing + fretSpacing / 2
          if let finger = position.finger {
            Circle()
              .fill(Color.red)
              .frame(width: 24, height: 24)
              .position(x: x, y: y)
            Text("\(finger)")
              .font(.caption)
              .fontWeight(.bold)
              .foregroundColor(.light)
              .position(x: x, y: y)
          } else {
            Circle()
              .fill(Color.red)
              .frame(width: 24, height: 24)
              .position(x: x, y: y)
            Text(input?.label ?? "")
              .font(.caption)
              .fontWeight(.bold)
              .foregroundColor(.light)
              .position(x: x, y: y)
          }
        }
      }
    }
  }
}

#Preview {
  Guitar(input: .chord(.B7))
}
