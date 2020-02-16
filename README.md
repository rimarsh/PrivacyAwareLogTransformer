# PrivacyAwareLogTransformer

> A simple logging middleware to help keep user information out of logs.

[![Build Status](https://github.com/rimarsh/PrivacyAwareLogTransformer/workflows/PrivacyAwareLogTransformer%20CI/badge.svg?branch=master)](https://github.com/rimarsh/PrivacyAwareLogTransformer/actions)
![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg)
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/rimarsh/PrivacyAwareLogTransformer)
[![License](https://img.shields.io/github/license/rimarsh/PrivacyAwareLogTransformer)](LICENSE)

Keeping your logs clear of personal user information and other private data is hard. PrivacyAwareLogTransformer helps you make intentional decisions about what to log.

Currently, developers need to be cautious with each log message they write to ensure that they are not leaking personal data. This is both tedious and error-prone, so why not ask the compiler to do protect from logging private data unintentionally.

PrivacyAwareLogTransformer ensures any variables emitted in logs have been sanitized. It then removes those variables and inserts a token while attaching the variable values in a dictionary.

As an added benefit, every log message will be emitted the same way regardless of the variables. This allows trend monitoring and alerting to work well since the log messages will not appear as different strings and therefore confuse the alerting system.

- [x] Natural logging syntax using string interpolation
- [x] Custom defined, per-type stringifications
- [x] Collatable log messages for easy metrics and alerting
- [x] Maintain control of how/where/when logs are emitted

Basically:
```swift
logger.log("a message with an object: \(User(name: "Bob"))")
```
Becomes:
```text
message: a message with an object: {{user_1}}, properties: ["user_1": "<safe value>"]
```

## Install

### Swift Package Manager

 [Swift Package Manager](https://swift.org/package-manager/) is the recommended way of consuming PrivacyAwareLogTransformer.
 To integrate it, add a dependency in your `Package.swift`:

```swift
 dependencies: [
   .package(url: "https://github.com/rimarsh/PrivacyAwareLogTransformer.git", from: "1.0")
 ],
```

### CocoaPods

To integrate PrivacyAwareLogTransformer into your Xcode project using [CocoaPods](https://cocoapods.org), specify it in your `Podfile`:

```ruby
pod 'PrivacyAwareLogTransformer', :git => 'https://github.com/rimarsh/PrivacyAwareLogTransformer.git'
```

### Carthage

To integrate PrivacyAwareLogTransformer into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "rimarsh/PrivacyAwareLogTransformer"
```

## Usage

1. Implement a `PrivacyAwareLogReceiver` to take transformed logs and send them to an existing logging infrastructure:

```swift
import PrivacyAwareLogTransformer

class LogReceiver: PrivacyAwareLogReceiver {
  func log(_ message: String, properties: [String : String]?, context: [AnyHashable : Any]?) {
      print("message: \(message), properties: \(properties ?? [:]), context: \(context ?? [:])")
  }
}
```

2. Initialize the log transformer in one place or many:

```swift
import PrivacyAwareLogTransformer

let receiver = LogReceiver()
var logger = PrivacyAwareLogTransformer()
logger.receiver = receiver
```

3. Logging can be done using a natural syntax

Assume, for example, two example data structures (one implements `PrivacyAwareLoggable` and the other does not):

```swift
struct User: PrivacyAwareLoggable {
    let userId: UUID = UUID()
    let name: String

    var loggingValue: String {
        return userId.uuidString
    }
}

struct Team {
    let team: UUID = UUID()
    let name: String
}
```

Logging a static string is just like any other log mechanism.

```swift
logger.log("a basic message")
```

Output:
```text
message: a basic message, properties: nil, context: nil
```

When logging an object, the object must conform to `PrivacyAwareLoggable`.
```swift
logger.log("a message with an object: \(User(name: "Bob"))")
```

Output:
```text
message: a message with an object: {{user_1}}, properties: ['user_1': <uuid>], context: nil
```

If the object doesn't conform to `PrivacyAwareLoggable`, it will fail to compile.
```swift
logger.log("a message with an object: \(Team(name: "My Team"))")
```

## Maintainer

[@rimarsh](https://github.com/rimarsh)

## Contributing

Feel free to dive in! [Open an issue](https://github.com/rimarsh/PrivacyAwareLogTransformer/issues/new) or submit a PR.

## License

MIT &copy; Riley Marsh. See [the LICENSE file](LICENSE) for more information.
