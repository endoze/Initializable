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

class InitializableSpec: QuickSpec {
  override func spec() {
    describe("ForegroundInitializer") {
      it("responds to perform(with:)") {
        let selector = #selector(Initializable.perform(with:))
        let initializer = ForegroundInitializer()

        initializer.perform(with: Configuration())
        
        expect(initializer.responds(to: selector)).to(beTrue())
      }

      context("if it implements the optional shouldPerformWhenApplicationEntersForeground") {
        it("responds to shouldPerformWhenApplicationEntersForeground") {
          let selector = #selector(Initializable.shouldPerformWhenApplicationEntersForeground)
          let initializer = ForegroundInitializer()
          
          expect(ForegroundInitializer().responds(to: selector)).to(beTrue())
          expect(initializer.shouldPerformWhenApplicationEntersForeground()).to(beTrue())
        }
      }

      context("if it doesn't implement the optional shouldPerformWhenAppilcationEntersForeground") {
        it("doesn't respond to shouldPerformWhenApplicationEntersForeground") {
          let selector = #selector(Initializable.shouldPerformWhenApplicationEntersForeground)
          let initializer = ApplicationLaunchOnlyInitializer()

          initializer.perform(with: Configuration())
          
          expect(ApplicationLaunchOnlyInitializer().responds(to: selector)).to(beFalse())
        }
      }
    }
  }
}
