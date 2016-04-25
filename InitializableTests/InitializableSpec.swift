//
//  InitializableSpec.swift
//  Initializable
//
//  Created by Endoze on 4/21/16.
//  Copyright © 2016 Wide Eye Labs. All rights reserved.
//

import Quick
import Nimble

import Initializable

class ForegroundInitializer: NSObject, Initializable {
  func performWithConfiguration(configuration: Configurable) {

  }

  func shouldPerformWhenApplicationEntersForeground() -> Bool {
    return true
  }
}

class ApplicationLaunchOnlyInitializer: NSObject, Initializable {
  func performWithConfiguration(configuration: Configurable) {

  }
}

class InitializableSpec: QuickSpec {
  override func spec() {
    describe("ForegroundInitializer") {
      it("responds to performWithConfiguration") {
        let selector = #selector(Initializable.performWithConfiguration)

        expect(ForegroundInitializer().respondsToSelector(selector)).to(beTrue())
      }

      context("if it implements the optional shouldPerformWhenApplicationEntersForeground") {
        it("responds to shouldPerformWhenApplicationEntersForeground") {
          let selector = #selector(Initializable.shouldPerformWhenApplicationEntersForeground)

          expect(ForegroundInitializer().respondsToSelector(selector)).to(beTrue())
        }
      }

      context("if it doesn't implement the optional shouldPerformWhenAppilcationEntersForeground") {
        it("doesn't respond to shouldPerformWhenApplicationEntersForeground") {
          let selector = #selector(Initializable.shouldPerformWhenApplicationEntersForeground)

          expect(ApplicationLaunchOnlyInitializer().respondsToSelector(selector)).to(beFalse())
        }
      }
    }
  }
}