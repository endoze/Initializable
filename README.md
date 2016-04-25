Initializable is a set of protocols that allow you to initialize third party
frameworks and other settings on app launch. It also allows your frameworks
to tie into `applicationDidEnterForeground`.

[![Build Status](https://travis-ci.org/endoze/Initializable.svg)](https://travis-ci.org/endoze/Initializable)
[![Coverage Status](https://coveralls.io/repos/github/endoze/Initializable/badge.svg?branch=master)](https://coveralls.io/github/endoze/Initializable?branch=master)
[![License](https://img.shields.io/cocoapods/l/Initializable.svg?style=flat)](http://cocoapods.org/pods/Initializable)
[![Platform](https://img.shields.io/cocoapods/p/Initializable.svg?style=flat)](http://cocoadocs.org/docsets/Initializable)
[![CocoaPods](https://img.shields.io/cocoapods/v/Initializable.svg?style=flat)](https://img.shields.io/cocoapods/v/Initializable.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Motivation

When building new applications, how many times do you pollute
`application:didFinishLaunchingWithOptions` with plenty of code initializing
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
pod 'Initializable'
```

Then run `pod install`

## Show me the code

If your language of choice is Swift:

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

Or if you prefer Objective-C:

```objective-c
// ThirdpartyInitializer.h

#import <Foundation/Foundation.h>
#import <Initializable/Initializable.h>

@interface ThirdpartyInitializer <Initializable>

@end
```

```objective-c
// ThirdpartyInitializer.m

#import "ThirdpartyInitializer.h"

@implementation ThirdpartyInitializer

- (void)performWithConfiguration:(id<Configurable>)configuration
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

```objective-c
// AppDelegate.m

#import "AppDelegate.h"
#import <Initializable/Initializable.h>

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
