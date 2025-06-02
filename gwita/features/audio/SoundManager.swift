import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    private init() {
    }


    func playSound(named name: String, withExtension ext: String = "m4a") {
        print("재생 시도: \(name).\(ext)")
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("사운드 파일을 찾을 수 없습니다: \(name).\(ext)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            print("사운드 재생 시작됨: \(name).\(ext)")
        } catch {
            print("사운드 재생 실패: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }
}
