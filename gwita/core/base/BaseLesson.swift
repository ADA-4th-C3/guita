//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

/// 비동기 함수 배열을 취소 가능하도록 만드는 클래스
/// [Task] 기반으로 비동기 함수를 실행하고 취소할 수 있음
class BaseLesson {
  func onLessonCancel(_: Error) {}

  func startLesson(_ jobs: [() async throws -> Void]) async {
    do {
      try await Task.sleep(nanoseconds: 100_000_000)
      for job in jobs {
        try Task.checkCancellation()
        try await job()
      }
    } catch {
      // Canceled
      onLessonCancel(error)
    }
  }
}
