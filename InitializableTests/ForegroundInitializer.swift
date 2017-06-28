//
//  ForegroundInitializer.swift
//  Initializable
//
//  Created by Endoze on 6/27/17.
//  Copyright © 2017 Wide Eye Labs. All rights reserved.
//

import Foundation
import Initializable

class ForegroundInitializer: NSObject, Initializable {
  func perform(with configuration: Configurable) {
    NSLog("Yup")
  }

  func shouldPerformWhenApplicationEntersForeground() -> Bool {
    return true
  }
}

