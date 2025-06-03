//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ThrottleAggregator<T: Hashable> {
  private let interval: TimeInterval
  private var lastEmitTime: TimeInterval = 0
  private var collected: [(value: T, confidence: Float)] = []
  private var timerStart: TimeInterval?

  init(interval: TimeInterval = 1.0) {
    self.interval = interval
  }

  func add(value: T, confidence: Float) -> (value: T, confidence: Float)? {
    let currentTime = Date().timeIntervalSince1970

    
    if timerStart == nil {
      timerStart = currentTime
    }

    collected.append((value, confidence))

    if currentTime - (timerStart ?? 0) >= interval {
      let grouped = Dictionary(grouping: collected, by: { $0.value })
      let mostFrequent = grouped.max(by: { $0.value.count < $1.value.count })?.key

      let avgConfidence: Float
      if let key = mostFrequent, let items = grouped[key] {
        avgConfidence = items.map { $0.confidence }.reduce(0, +) / Float(items.count)
      } else {
        avgConfidence = 0
      }

      timerStart = currentTime
      collected.removeAll()

      if let value = mostFrequent {
        return (value, avgConfidence)
      }
    }

    return nil
  }
}
