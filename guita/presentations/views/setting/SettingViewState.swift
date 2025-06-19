//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct SettingViewState {
  let config: Config
  let showGuideDialog: Bool
  let showDeniedDialog: Bool

  func copy(
    config: Config? = nil,
    showGuideDialog: Bool? = nil,
    showDeniedDialog: Bool? = nil
  ) -> SettingViewState {
    return SettingViewState(
      config: config ?? self.config,
      showGuideDialog: showGuideDialog ?? self.showGuideDialog,
      showDeniedDialog: showDeniedDialog ?? self.showDeniedDialog
    )
  }
}
