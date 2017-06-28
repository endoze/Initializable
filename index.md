Initializable is a set of protocols that allow you to initialize third party
frameworks and other settings on app launch. It also allows your frameworks
to tie into `applicationDidEnterForeground:`.

[![Build Status](https://travis-ci.org/endoze/Initializable.svg)](https://travis-ci.org/endoze/Initializable)
[![Coverage Status](https://coveralls.io/repos/github/endoze/Initializable/badge.svg?branch=master)](https://coveralls.io/github/endoze/Initializable?branch=master)
[![License](https://img.shields.io/cocoapods/l/Initializable.svg?style=flat)](http://cocoapods.org/pods/Initializable)
[![Platform](https://img.shields.io/cocoapods/p/Initializable.svg?style=flat)](http://cocoadocs.org/docsets/Initializable)
[![CocoaPods](https://img.shields.io/cocoapods/v/Initializable.svg?style=flat)](https://img.shields.io/cocoapods/v/Initializable.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Motivation

When building new applications, how many times do you pollute
`application:didFinishLaunchingWithOptions:` with plenty of code initializing
third party frameworks or other app wide settings? This framework is designed
to help cut down on the noise in your AppDelegate and allow this code to be
separated into objects each with their own responsibility.

## Features

- Small public API surface
- Works with your own custom objects
- Customizeable via method implementation
- Well documented
- Tested
- Support For Cocoapods/Carthage integration

## Installation

### Carthage

Add the following to your Cartfile:

```
github "Endoze/Initializable"
```

Then add the framework as a linked framework.

### CocoaPods

Add the following to your Podfile:

```
use_frameworks!


pod 'Initializable'
```

Then run `pod install`

## Show me the code

### If your language of choice is Swift

You need to implement a couple objects that conform to the Configurable
protocol and the Initializable protocol.

```swift
// Configuration.swift

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

  // Notice we don't define `configurationValueForService:key:` in Swift
  // this is because of the default implementation provided by the
  // extension to Configurable
}
```

```Swift
// ThirdpartyInitializer.swift

import Initializable

class ThirdpartyInitializer: NSObject, Initializable {
  func performWithConfiguration(configuration: Configuration) {
    let apiKey = configuration.configurationValueForService("ThirdParty", "apiKey")
    let _ = Thirdparty(apiKey: apiKey)
  }

  func shouldPerformWhenApplicationEntersForeground() -> Bool {
    return false
  }
}
```

Then jump into your Application Delegate and hook the initializer(s) into
application lifecycle methods.

```Swift
// AppDelegate.swift

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let initializers: [Initializable] = [
    ThirdPartyInitializer(),
  ]
  let configuration = Configuration.defaultConfiguration()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    for initializer in initializers {
      initializer.performWithConfiguration(configuration: configuration)
    }

    return true
  }

  func applicationWillEnterForeground(application: UIApplication) {
    for initializer in initializers {
      if initializer.respondsToSelector(#selector(Initializable.shouldPerformWhenApplicationEntersForeground)) {
        initializer.performWithConfiguration(configuration)
      }
    }
  }

  // ...
}
```

### Or if you prefer Objective-C

You need to implement a couple objects that conform to the Configurable
protocol and the Initializable protocol.

```objective-c
// Configuration.h

#import <Foundation/Foundation.h>

@import Initializable;

@interface Configuration : NSObject <Configurable>

@property (nonatomic, copy) NSDictionary<NSString *, NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> *> *serviceStorage;

@end
```

```objective-c
// Configuration.m

#import "Configuration.h"

@implementation Configuration

+ (Configuration *)defaultConfiguration
{
  static id instance = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      instance = [[self alloc] init];
  });

  return instance;
}

- (ReleaseStage)currentStage
{
  return ReleaseStageDevelopment;
}

- (NSDictionary *)serviceStorage
{
  if (!_serviceStorage) {
    _serviceStorage = @{
      @(ReleaseStageDevelopment) : @{
        @"FakeService": @{
          @"apiKey": @"abc123"
        }
      }
    };
  }

  return _serviceStorage;
}

// Notice we define `configurationValueForService:key:` in Objective-C
// this is because the default implementation provided by the extension
// to Configurable is not visible to Objective-C code.
- (NSString *)configurationValueForService:(NSString *)service key:(NSString *)key
{
  Configuration *configuration = [Configuration defaultConfiguration];
  NSDictionary *serviceStorage = [configuration serviceStorage];
  NSDictionary *stageStorage = serviceStorage[@([configuration currentStage])];
  NSDictionary *serviceKeys;

  if (stageStorage) {
    if ((serviceKeys = stageStorage[service])) {
      return serviceKeys[key];
    }
  }

  return nil;
}

@end
```

```objective-c
// ThirdpartyInitializer.h

#import <Foundation/Foundation.h>

@import Initializable;

@interface ThirdpartyInitializer <Initializable>

@end
```

```objective-c
// ThirdpartyInitializer.m

#import "ThirdpartyInitializer.h"

@implementation ThirdpartyInitializer

// Notice we substitute id<Configurable> here for our custom class that
// implements the Configurable protocol in the method implementation
- (void)performWithConfiguration:(Configuration *)configuration
{
  NSString *apiKey = [configuration configurationValueForService:@"Thirdparty" key:@"apiKey"];
  [Thirdparty initWithApiKey:apiKey];
}

- (BOOL)shouldPerformWhenApplicationEntersForeground
{
  return NO;
}

@end
```

Then jump into your Application Delegate and hook the initializer(s) into
application lifecycle methods.

```objective-c
// AppDelegate.m

#import "AppDelegate.h"

@import Initializable;

@interface AppDelegate ()

@property (nonatomic, strong) NSArray<id<Initializable>> *initializers;

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self.initializers makeObjectsPerformSelector:@selector(performWithConfiguration:) withObject:[Configuration defaultConfiguration]];

  return YES
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [self.initializers enumerateObjectsUsingBlock:^void(id<Initializer> initializer, NSUInteger index, BOOL *stop) {
    if ([initializer respondsToSelector:@selector(shouldPerformWhenApplicationEntersForeground)] &&
        [initializer shouldPerformWhenApplicationEntersForeground]) {
      [initializer performWithConfiguration:[Configuration defaultConfiguration]];
    }
  }];
}

- (NSArray<id <Initializer>> *)initializers
{
  if (!_initializers) {
    _initializers = @[
      [ThirdPartyInitializer new],
    ];
  }

  return _initializers;
}

@end
```
