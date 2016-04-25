//
//  Initializer.swift
//  Initializer
//
//  Created by Endoze on 4/21/16.
//  Copyright © 2016 Wide Eye Labs. All rights reserved.
//

import Foundation

/**
 *  This protocol defines methods that your custom object implements in order to be Initializable.
 */
@objc public protocol Initializable: NSObjectProtocol {
  /**
   This method is called when the application is launched and potentially when the application enters the foreground.

   - parameter configuration: An object that conforms to the Configurable protocol.
   */
  func performWithConfiguration(configuration: Configurable)

  /**
   This method is called when the application is entering the foreground. Depending on the return value, `performWithConfiguration` is called.

   - returns: Boolean value indicating whether `Initializable.performWithConfiguration`_ should be called when the application enters the foreground.
   */
  optional func shouldPerformWhenApplicationEntersForeground() -> Bool
}