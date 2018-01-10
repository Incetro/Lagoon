//
//  CompoundOperation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

/// CompoundOperation's success block

public typealias CompoundOperationSuccessBlock<T> = (_ data: T) -> ()

/// CompoundOperation's failure block

public typealias CompoundOperationFailureBlock = (_ error: Error) -> ()

// MARK: - CompoundOperation

public class CompoundOperation<OutputDataType>: AsyncOperation {
    
    // MARK: - Properties
    
    /// OperationQueue with all operations
    private let queue: OperationQueue
    
    /// Configurator for setup operations chain
    private let configurator: OperationChainConfigurator
    
    /// Input data (from the first operation)
    private var inputData: Any? = nil
    
    /// success block
    public var success: CompoundOperationSuccessBlock<OutputDataType>? = nil
    
    /// failure block
    public var failure: CompoundOperationFailureBlock? = nil
    
    /// true, if current operation was configured
    private var isConfigured: Bool
    
    /// Buffer with output data
    private var outputBuffer: OperationBuffer? = nil
    
    public var maxConcurrentOperationCount: Int {
        get { return queue.maxConcurrentOperationCount }
        set { queue.maxConcurrentOperationCount = newValue }
    }
    
    /// Current operations chain
    
    public var chainableOperations: [ChainableOperation] = []
    
    // MARK: - Initializers
    
    /// Standard initializer
    ///
    /// - Parameters:
    ///   - queue: OperationQueue for operations
    ///   - configurator: configurator for setup operations chain
    internal init(withOperationQueue queue: OperationQueue, configurator: OperationChainConfigurator) {
        self.queue = queue
        self.configurator = configurator
        self.isConfigured = false
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - queue: OperationQueue for operations
    ///   - configurator: configurator for setup operations chain
    /// - Returns: CompoundOperation instance
    internal static func compoundOperationWithOperationQueue(withOperationQueue queue: OperationQueue, configurator: OperationChainConfigurator) -> CompoundOperation {
        return CompoundOperation(withOperationQueue: queue, configurator: configurator)
    }
    
    /// Initializer
    ///
    /// - Returns: configurator for setup operations chain
    public static func `default`(withOutputDataType type: OutputDataType.Type) -> CompoundOperation {
        let queue = OperationQueue.suspendedOperationQueueWithMaximumConcurentOperations()
        let configurator = OperationChainConfiguratorImplementation.defaultOperationChainConfigurator()
        return CompoundOperation(withOperationQueue: queue, configurator: configurator)
    }
    
    // MARK: - Internal
    
    /// Setup operations chain
    ///
    /// - Parameter chainableOperations: all operations for setup
    public func configure<T: AsyncChainableOperation>(withChainableOperations chainableOperations: [T]) {
        configure(withChainableOperations: chainableOperations, inputData: nil)
    }
    
    /// Setup operations chain
    ///
    /// - Parameters:
    ///   - chainableOperations: all operations for setup
    ///   - inputData: input data
    public func configure<T: AsyncChainableOperation>(withChainableOperations chainableOperations: [T], inputData: Any?) {
        configure(withChainableOperations: chainableOperations, inputData: inputData, success: nil, failure: nil)
    }
    
    /// Setup operations chain
    ///
    /// - Parameters:
    ///   - chainableOperations: all operations for setup
    ///   - success: success block
    ///   - failure: failure block
    public func configure<T: AsyncChainableOperation>(withChainableOperations chainableOperations: [T], success: CompoundOperationSuccessBlock<OutputDataType>?, failure: CompoundOperationFailureBlock?) {
        configure(withChainableOperations: chainableOperations, inputData: nil, success: success, failure: failure)
    }
    
    /// - Parameters:
    ///   - chainableOperations: all operations for setup
    ///   - inputData: input data for the first operation
    ///   - success: success block
    ///   - failure: failure block
    public func configure<T: AsyncChainableOperation>(withChainableOperations chainableOperations: [T], inputData: Any?, success: CompoundOperationSuccessBlock<OutputDataType>?, failure: CompoundOperationFailureBlock?) {
        self.chainableOperations = chainableOperations
        self.success = success
        self.failure = failure
        self.inputData = inputData
        self.outputBuffer = configurator.configureOperationsChain(chainableOperations, withInputData: inputData as Any)
        addSuboperationsToQueue(chainableOperations)
        isConfigured = true
    }
    
    override public func main() {
        if isConfigured {
            queue.isSuspended = false
        }
    }
    
    private func addSuboperationsToQueue<T: AsyncChainableOperation>(_ operations: [T]) {
        for operation in operations {
            queue.addOperation(operation)
            operation.delegate = self
        }
    }
    
    /// Current operation was finished success
    ///
    /// - Parameter data: output data
    private func successOperation(withData data: OutputDataType) {
        finishCompoundOperationExecution()
        success?(data)
    }
    
    /// Current operation was interrupted with error
    ///
    /// - Parameter error: some error
    private func failureOperation(withError error: Error) {
        finishCompoundOperationExecution()
        failure?(error)
    }
    
    /// Complete queue's operations
    private func finishCompoundOperationExecution() {
        queue.isSuspended = true
        queue.cancelAllOperations()
        complete()
    }
}

// MARK: - ChainableOperationDelegate

extension CompoundOperation: ChainableOperationDelegate {
    
    public func operationSuccess() {
        if let data = outputBuffer?.obtainOperationQueueOutputData() as? OutputDataType {
            successOperation(withData: data)
        }
    }
    
    public func operationFailure(withError error: Error) {
        failureOperation(withError: error)
    }
}
