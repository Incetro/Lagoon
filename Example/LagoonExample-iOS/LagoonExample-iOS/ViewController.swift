//
//  ViewController.swift
//  LagoonExample-iOS
//
//  Created by incetro on 11/07/2017.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit
import Lagoon

class ConvertOperation: ChainableOperationBase<String, Int> {
    
    override func process(inputData: String, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        if let result = Int(inputData) {
            success(result)
        } else {
            failure(NSError(domain: "com.incetro.Lagoon.Example", code: 1, userInfo: nil))
        }
    }
}

class IncrementOperation: ChainableOperationBase<Int, Int> {
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData + 1)
    }
}

class DecrementOperation: ChainableOperationBase<Int, Int> {
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData - 1)
    }
}

class MultiplicationOperation: ChainableOperationBase<Int, Int> {
    
    let mult: Int
    
    init(with mult: Int) {
        self.mult = mult
    }
    
    override func process(inputData: Int, success: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        success(inputData * self.mult)
    }
}

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

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let strings = ["123", "4", "56a", "a", ""]
        
        for string in strings {
            
            let convert = ConvertOperation()
            let increment = IncrementOperation()
            let decrement = DecrementOperation()
            let mult = MultiplicationOperation(with: 125)
            let array = ArrayOperation()
            
            let operations = [convert, increment, decrement, mult, array]
            let compoundOperation = CompoundOperation.default(withOutputDataType: [Int].self)
            
            compoundOperation.configure(withChainableOperations: operations, inputData: string, success: { result in
                print(result)
            }, failure: { error in
                print(error.localizedDescription)
            })
            
            Lagoon.add(operation: compoundOperation)
        }
    }
}
