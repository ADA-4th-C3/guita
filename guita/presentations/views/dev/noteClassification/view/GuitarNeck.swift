//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct GuitarNeck: View {
    var note: Note
    var body: some View {
        GeometryReader { geometry in
            let stringCount = 6
            let fretCount = 20
            let openFretOffset: CGFloat = 1.0
            let notePositions = note.coordinates
            let markerFrets: Set<Int> = [3, 5, 7, 9, 12, 15, 17]
            
            let width = geometry.size.width
            let height = geometry.size.height
            let fretSpacing = height / CGFloat(fretCount + Int(openFretOffset))
            let stringSpacing = width / CGFloat(stringCount + 1)

            ZStack {
                // Draw strings
                ForEach(1...stringCount, id: \.self) { string in
                    let x = CGFloat(string) * stringSpacing
                    Path { path in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    .stroke(lineWidth: 5)
                    .foregroundStyle(.gray)
                }

                // Draw frets
                ForEach(1...fretCount, id: \.self) { fret in
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
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                        .position(x: width / 2, y: y)
                }

                // Draw note positions
                ForEach(Array(notePositions.enumerated()), id: \.offset) { _, position in
                    let x = width - (CGFloat(position.string) * stringSpacing)
                    let y = (CGFloat(position.fret) + openFretOffset) * fretSpacing + fretSpacing/2
                    Text("\(note)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

#Preview {
    GuitarNeck(note: .F2)
}
