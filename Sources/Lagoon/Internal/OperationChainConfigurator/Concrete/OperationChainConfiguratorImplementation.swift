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
    
    fileprivate var bufferFactory: OperationBuffersFactory
    
    /// Chainer for the input operations
    
    fileprivate var chainer: OperationChainer
    
    // MARK: - Initializers
    
    /// Internal initializer
    ///
    /// - Parameters:
    ///   - chainer: Chainer for the input operations
    ///   - bufferFactory: Buffers' factory
    
    internal init(withOperationChainer chainer: OperationChainer, andOperationBuffersFactory bufferFactory: OperationBuffersFactory) {
        
        self.chainer = chainer
        self.bufferFactory = bufferFactory
    }
    
    /// Standard internal initializer
    ///
    /// - Returns: self instance
    
    internal static func defaultOperationChainConfigurator() -> OperationChainConfiguratorImplementation {
        
        let defaultBufferFactory     = OperationBuffersFactoryImplementation()
        let operationChainersFactory = OperationChainersFactoryImplementation()
        let defaultChainer           = operationChainersFactory.createDataFlowOperationChainer()
        
        return OperationChainConfiguratorImplementation(withOperationChainer: defaultChainer, andOperationBuffersFactory: defaultBufferFactory)
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
     /// - Returns: Output buffer
    
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
            
            fatalError("Array size must be not empty")
        }
        
        configureInput(withData: inputData, forFirstOperation: &firstOperation)
        
        configureChain(withOperations: chainableOperations)
        
        let outputBuffer = configureOutput(forLastOperation: &lastOperation)
        
        return outputBuffer
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        guard let bufferFactory = self.bufferFactory.copy(with: nil) as? OperationBuffersFactory, let chainer = self.chainer.copy(with: nil) as? OperationChainer else {
            
            fatalError()
        }
        
        let copy = OperationChainConfiguratorImplementation(withOperationChainer: chainer, andOperationBuffersFactory: bufferFactory)
        
        return copy
    }
}
