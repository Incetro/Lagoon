//
//  OperationChainConfiguratorImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainConfiguratorImplementation

internal class OperationChainConfiguratorImplementation {
    
    // MARK: - Properties
    
    /// Buffers' factory
    private var bufferFactory: OperationBufferFactory

    /// Chainer for the input operations
    private var chainer: OperationChainer
    
    // MARK: - Initializers
    
    /// Internal initializer
    ///
    /// - Parameters:
    ///   - chainer: chainer for the input operations
    ///   - bufferFactory: buffers factory
    internal init(chainer: OperationChainer, bufferFactory: OperationBufferFactory) {
        self.chainer = chainer
        self.bufferFactory = bufferFactory
    }
    
    /// Standard internal initializer
    ///
    /// - Returns: self instance
    internal static func defaultOperationChainConfigurator() -> OperationChainConfiguratorImplementation {
        let defaultBufferFactory = OperationBufferFactoryImplementation()
        let operationChainerFactory = OperationChainerFactoryImplementation()
        let defaultChainer = operationChainerFactory.createDataFlowOperationChainer()
        return OperationChainConfiguratorImplementation(chainer: defaultChainer, bufferFactory: defaultBufferFactory)
    }
    
    // MARK: - Internal
    
    /// Setup the first operation
    ///
    /// - Parameters:
    ///   - data: Input data
    ///   - firstOperation: first operation in the chain
    internal func configureInput<T: AsyncChainableOperation>(withData data: Any, forFirstOperation firstOperation: inout T) {
        let inputBuffer = bufferFactory.createChainableOperationsBuffer()
        inputBuffer.setOperationQueueInputData(data)
        firstOperation.input = inputBuffer
    }
    
    /// Setup the all operations except first and last
    ///
    /// - Parameter operations: all operations
    internal func configureChain<T: AsyncChainableOperation>(withOperations operations: [T]) {
        for i in 0..<operations.count - 1 {
            var currentOperation = operations[i]
            var nextOperation = operations[i + 1]
            chainer.chainOperation(&currentOperation, withOperation: &nextOperation)
        }
    }
    
     /// Setup the last operation
     ///
     /// - Parameter lastOperation: last operation in the chain
     /// - Returns: output buffer
    internal func configureOutput<T: AsyncChainableOperation>(forLastOperation lastOperation: inout T) -> OperationBuffer {
        let outputBuffer = bufferFactory.createChainableOperationsBuffer()
        lastOperation.output = outputBuffer
        return outputBuffer
    }
}

// MARK: - OperationChainConfigurator

extension OperationChainConfiguratorImplementation: OperationChainConfigurator {
    
    public func configureOperationsChain<T: AsyncChainableOperation>(_ chainableOperations: [T], withInputData inputData: Any) -> OperationBuffer {
        guard var firstOperation = chainableOperations.first, var lastOperation = chainableOperations.last else {
            fatalError("Array size mustn't be empty")
        }
        configureInput(withData: inputData, forFirstOperation: &firstOperation)
        configureChain(withOperations: chainableOperations)
        return configureOutput(forLastOperation: &lastOperation)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        guard let bufferFactory = bufferFactory.copy(with: nil) as? OperationBufferFactory else {
            fatalError()
        }
        guard let chainer = chainer.copy(with: nil) as? OperationChainer else {
            fatalError()
        }
        return OperationChainConfiguratorImplementation(chainer: chainer, bufferFactory: bufferFactory)
    }
}
