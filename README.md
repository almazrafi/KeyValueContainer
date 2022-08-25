# KeyValueContainer
[![Build Status](https://github.com/almazrafi/KeyValueContainer/workflows/CI/badge.svg?branch=master)](https://github.com/almazrafi/KeyValueContainer/actions)
[![Codecov](https://codecov.io/gh/almazrafi/KeyValueContainer/branch/master/graph/badge.svg)](https://codecov.io/gh/almazrafi/KeyValueContainer)
[![Cocoapods](https://img.shields.io/cocoapods/v/KeyValueContainer.svg?style=flat)](http://cocoapods.org/pods/KeyValueContainer)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/cocoapods/p/KeyValueContainer.svg?style=flat)](https://developer.apple.com/discover/)
[![Xcode](https://img.shields.io/badge/Xcode-11-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/github/license/almazrafi/KeyValueContainer.svg)](https://opensource.org/licenses/MIT)

## Requirements
- iOS 10.0+ / macOS 10.12+ / watchOS 3.0+ / tvOS 10.0+
- Xcode 12.5+
- Swift 5.1+

## Usage
#### Declare a container:
``` swift
extension PersistentStorage {
    var foobar: KeyValueContainer<Int> {
        makeContainer()
    }
}
```

This will create a container with the same key as property name: "foobar"

#### Reading a value from the storage:
``` swift
let foobar = PersistentStorage.default.foobar.value
```

Same as using UserDefaults:
``` swift
let foobar = UserDefaults.standard.integer(forKey: "foobar")
```

#### Writing a value to the storage:
``` swift
PersistentStorage.default.foobar.value = 123
```

Same as using UserDefaults:
``` swift
UserDefaults.standard.set(123, forKey: "foobar")
```

## Installation
### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
$ gem install cocoapods
```

To integrate KeyValueContainer into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:
```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'KeyValueContainer'
end
```

Finally run the following command:
```bash
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with Homebrew using the following command:
```bash
$ brew update
$ brew install carthage
```

To integrate KeyValueContainer into your Xcode project using Carthage, specify it in your `Cartfile`:
```ogdl
github "almazrafi/KeyValueContainer" ~> 1.0.1
```

Finally run `carthage update` to build the framework and drag the built `KeyValueContainer.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate KeyValueContainer into your Xcode project using Swift Package Manager,
add the following as a dependency to your `Package.swift`:
```swift
.package(url: "https://github.com/almazrafi/KeyValueContainer.git", from: "1.0.1")
```
and then specify `"KeyValueContainer"` as a dependency of the Target in which you wish to use KeyValueContainer.

Here's an example `Package.swift`:
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(name: "MyPackage", targets: ["MyPackage"])
    ],
    dependencies: [
        .package(url: "https://github.com/almazrafi/KeyValueContainer.git", from: "1.0.1")
    ],
    targets: [
        .target(name: "MyPackage", dependencies: ["KeyValueContainer"])
    ]
)
```

## Communication
- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

## License
KeyValueContainer is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
