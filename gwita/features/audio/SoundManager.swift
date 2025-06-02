//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import AVFoundation

final class SoundPlayerManager {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    private init() {}

    func playSound(named name: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("사운드 파일을 찾을 수 없습니다: \(name).\(ext)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("사운드 재생 실패: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }
}
