//: Playground - noun: a place where people can play

import Initializable

class CoolInitializer: NSObject, Initializable {
  func performWithConfiguration(configuration: Configurable) {

  }

  func shouldPerformWhenApplicationEntersForeground() -> Bool {
    return true
  }
}