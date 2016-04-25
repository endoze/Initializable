//
//  ConfigurableSpec.swift
//  Initializable
//
//  Created by Endoze on 4/21/16.
//  Copyright © 2016 Wide Eye Labs. All rights reserved.
//

import Quick
import Nimble
import Initializable

class Configuration: NSObject, Configurable {
  static let sharedConfiguration = Configuration()

  var serviceStorage: [String : [Int : [String : String]]] = [:]

  override init() {
    serviceStorage = [
      "FakeService" : [
        ReleaseStage.Development.rawValue : [
          "ApiKey": "abc123"
        ]
      ]
    ]
  }

  static func defaultConfiguration() -> Configurable {
    return sharedConfiguration
  }

  func currentStage() -> ReleaseStage {
    return .Development
  }
}

class ConfigurableSpec: QuickSpec {
  override func spec() {
    describe("Configurable") {
      describe("currentStage") {
        it("returns a ReleaseStage") {
          let configuration = Configuration.defaultConfiguration()

          expect(configuration.currentStage()).to(equal(ReleaseStage.Development))
        }
      }

      describe("serviceStorage") {
        let configuration = Configuration.defaultConfiguration()

        context("when a value exists for a service") {
          it("returns a key") {
            expect(configuration.configurationValueForService("FakeService", key: "ApiKey")).to(equal("abc123"))
          }
        }

        context("when a value doesn't exist for a service") {
          it("returns nil") {
            expect(configuration.configurationValueForService("FakeService", key: "DoesNotExist")).to(beNil())
          }
        }
      }
    }
  }
}