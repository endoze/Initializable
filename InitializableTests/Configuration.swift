//
//  Configuration.swift
//  Initializable
//
//  Created by Endoze on 6/27/17.
//  Copyright © 2017 Wide Eye Labs. All rights reserved.
//

import Foundation
import Initializable

class Configuration: NSObject, Configurable {
  static let sharedConfiguration = Configuration()

  var serviceStorage: [String : [Int : [String : String]]] = [:]

  override init() {
    serviceStorage = [
      "FakeService" : [
        ReleaseStage.development.rawValue : [
          "ApiKey": "abc123"
        ]
      ]
    ]
  }

  static func defaultConfiguration() -> Configurable {
    return sharedConfiguration
  }

  func currentStage() -> ReleaseStage {
    return .development
  }
}

