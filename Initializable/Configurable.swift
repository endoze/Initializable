//
//  Configurable.swift
//  Initializer
//
//  Created by Endoze on 4/21/16.
//  Copyright © 2016 Wide Eye Labs. All rights reserved.
//

import Foundation
/**
 Enum to describe the various release stages of an application.

 - Development: An app in development
 - Test:        An app in testing
 - Production:  An app in production
 */
@objc public enum ReleaseStage: Int {
  case Development
  case Test
  case Production
}

/**
 *  This protocol defines an object that can be used as configuration for an Initializable. It contains storage for configuration keys and values separated by each development stage.
 */
@objc public protocol Configurable: NSObjectProtocol {
  /// Used to store service keys and values based on `ReleaseStage`
  var serviceStorage: [String: [Int: [String: String]]] { get set }

  /**
   This method returns the default configuration that can be used app wide.

   - returns: An object that is Configurable
   */
  static func defaultConfiguration() -> Configurable

  /**
   This method returns the current ReleaseStage according to the current instance of Configurable.

   - returns: The current ReleaseStage
   */
  func currentStage() -> ReleaseStage

  /**
   This method is the default way to access configuration keys and values based on the current ReleaseStage

   - parameter service: Key representing the service to pull keys from
   - parameter key:     Key representing the service key to pull values from

   - returns: Returns the stored service key value or nil if it's not present
   */
  optional func configurationValueForService(service: String, key: String) -> String?
}

public extension Configurable {
  /**
   This method is the default way to access configuration keys and values based on the current ReleaseStage

   - parameter service: Key representing the service to pull keys from
   - parameter key:     Key representing the service key to pull values from

   - returns: Returns the stored service key value or nil if it's not present
   */
  func configurationValueForService(service: String, key: String) -> String? {
    return serviceStorage[service]?[currentStage().rawValue]?[key]
  }
}