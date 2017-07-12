Lagoon
==========

[![Build Status](https://travis-ci.org/incetro/Lagoon.svg?branch=master)](https://travis-ci.org/incetro/Lagoon)
[![CocoaPods](https://img.shields.io/cocoapods/v/Lagoon.svg)](https://img.shields.io/cocoapods/v/Lagoon.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/incetro/Lagoon/master/LICENSE.md)
[![Platforms](https://img.shields.io/cocoapods/p/Lagoon.svg)](https://cocoapods.org/pods/Lagoon)

Lagoon is a framework written in Swift that makes it easy for you to organize your service layer

- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Author](#author)
- [License](#license)

## Features
- [x] Asynchronous operations
- [x] SOLID out of the box
- [x] Very simple writing unit tests
- [x] Reusable business logic
- [x] Generics

## Usage
### Look at the simple example
Here we convert our string to number, increment and decrement it, multiply and divide by digits.
Let's create our operations:
```swift

/// Convert String to Int
class ConvertOperation: ChainableOperationBase<String, Int> {
    
    override func process(inputData: String, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        
        if let result = Int(inputData) {
            success(result)
        } else {
            failure(NSError(domain: "com.incetro.Lagoon.Example", code: 1, userInfo: nil))
        }
    }
}

/// Increment the given number
class IncrementOperation: ChainableOperationBase<Int, Int> {
    
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData + 1)
    }
}

/// Decrement the given number
class DecrementOperation: ChainableOperationBase<Int, Int> {
    
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData - 1)
    }
}

/// Multiply the given number
class MultiplicationOperation: ChainableOperationBase<Int, Int> {
    
    let mult: Int
    
    init(with mult: Int) {
        self.mult = mult
    }
    
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData * self.mult)
    }
}

/// Make array of digits from the given number
class ArrayOperation: ChainableOperationBase<Int, [Int]> {
    
    override func process(inputData: Int, success: @escaping ([Int]) -> (), failure: @escaping (Error) -> ()) {
        
        var result: [Int] = []
        var number = inputData
        
        while number > 0 {
            
            result.append(number % 10)
            number = number / 10
        }
        
        success(result.reversed())
    }
}
```
And make chain ```convert -> increment -> decrement -> multiplication -> array```
```swift
let strings = ["123", "4", "56a", "a", ""]
        
for string in strings {
            
    let convert   = ConvertOperation()
    let increment = IncrementOperation()
    let decrement = DecrementOperation()
    let mult      = MultiplicationOperation(with: 125)
    let array     = ArrayOperation()
            
    /// Create chain
    let operations = [convert, increment, decrement, mult, array]
            
    /// We expect Int array as output type
    let compoundOperation = CompoundOperation.default(withOutputDataType: [Int].self)
    
    /// Setup compound operation
    compoundOperation.configure(withChainableOperations: operations, inputData: string, success: { result in
                
        print(result)
                
    }, failure: { error in
                
        print(error.localizedDescription)
    })
    
    /// Start it!
    Lagoon.add(operation: compoundOperation)
}
```
## Advanced usage
Okay, how can you use it in the real projects? Look at this.
```swift
// MARK: - RequestDataSigningOperation
class RequestDataSigningOperation: ChainableOperationBase<RequestDataModel, RequestDataModel> {
    
    private let requestSigner: RequestDataSigner
    
    init(withRequestSigner requestSigner: RequestDataSigner) {
        
        self.requestSigner = requestSigner
    }
    
    override func process(inputData: RequestDataModel, success: @escaping (RequestDataModel) -> (), failure: @escaping (Error) -> ()) {
        
        let signedRequestDataModel = requestSigner.signRequestDataModel(inputData)
        
        success(signedRequestDataModel)
    }
}

// MARK: - RequestConfigurationOperation
class RequestConfigurationOperation: ChainableOperationBase<RequestDataModel, URLRequest> {
    
    private let requestConfigurator: RequestConfigurator
    private let method: HTTPMethod
    private let serviceName: String?
    private let urlParameters: [String]
    private let queryType: QueryType
    
    init(configurator: RequestConfigurator, method: HTTPMethod, type: QueryType, serviceName: String?, urlParameters: [String]) {
        
        self.requestConfigurator  = configurator
        
        self.method        = method
        self.queryType     = type
        self.serviceName   = serviceName
        self.urlParameters = urlParameters
    }
    
    // MARK: - ChainableOperationBase
    
    override func process(inputData: RequestDataModel, success: @escaping (URLRequest) -> (), failure: @escaping (Error) -> ()) {
        
        let request = requestConfigurator.createRequest(withMethod:       self.method,
                                                        type:             self.queryType,
                                                        serviceName:      self.serviceName,
                                                        urlParameters:    self.urlParameters,
                                                        requestDataModel: inputData)
        
        success(request)
    }
}

/// And other operations...
/// Then use it to make network chain

let operations = [

    requestDataSigningOperation,
    requestConfigurationOperation,
    networkRequestOperation,
    deserializationOperation,
    validationOperation,
    responseCachingOperation,
    responseMappingOperation
]

let compoundOperation = CompoundOperation.default(withOutputDataType: User.self)
        
compoundOperation.maxConcurrentOperationCount = 1
        
compoundOperation.configure(withChainableOperations: operations, inputData: inputData, success: success, failure: failure)
```
## Requirements
- iOS 8.0+ / macOS 10.9+
- Xcode 8.1, 8.2, 8.3, and 9.0
- Swift 3.0, 3.1, 3.2, and 4.0

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Lagoon into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target "<Your Target Name>" do
    pod "Lagoon"
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use any dependency managers, you can integrate Lagoon into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Lagoon as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/incetro/Lagoon.git
  ```

- Open the new `Lagoon` folder, and drag the `Lagoon.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Lagoon.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Lagoon.xcodeproj` folders each with two different versions of the `Lagoon.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `Lagoon.framework`.

- Select the top `Lagoon.framework` for iOS and the bottom one for OS X.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Lagoon` will be listed as either `Lagoon iOS`, `Lagoon macOS`.

- And that's it!

  > The `Lagoon.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
  
## Author

incetro, incetro@ya.ru. Inspired by [COOperation](https://github.com/strongself/COOperation)

## License

Lagoon is available under the MIT license. See the LICENSE file for more info.
