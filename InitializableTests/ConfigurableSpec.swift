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

class ConfigurableSpec: QuickSpec {
  override func spec() {
    describe("Configurable") {
      describe("currentStage") {
        it("returns a ReleaseStage") {
          let configuration = Configuration.defaultConfiguration()

          expect(configuration.currentStage()).to(equal(ReleaseStage.development))
        }
      }

      describe("serviceStorage") {
        let configuration = Configuration.defaultConfiguration()

        context("when a value exists for a service") {
          it("returns a key") {
            expect(configuration.value(for: "FakeService", key: "ApiKey")).to(equal("abc123"))
          }
        }

        context("when a value doesn't exist for a service") {
          it("returns nil") {
            expect(configuration.value(for: "FakeService", key: "DoesNotExist")).to(beNil())
          }
        }
      }
    }
  }
}
