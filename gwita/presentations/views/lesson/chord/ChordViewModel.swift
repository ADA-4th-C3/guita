//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ChordViewModel: BaseViewModel<ChordViewState> {
  init(_ songInfo: SongInfo) {
    super.init(state: .init(songInfo: songInfo))
  }
}
