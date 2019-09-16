//
//  VectorOperation.swift
//  Lagoon
//
//  Created by incetro on 16/09/2019.
//

import Foundation

// MARK: - VectorOperation

public class VectorOperation<I, O>: ChainableOperationBase<[I], [O]> {

    // MARK: - Properties

    /// Queue with all suboperations
    private let queue = OperationQueue.operationQueueWithMaximumConcurentOperations()

    /// Closure which describes how we can form our operations for execution
    private let operationFactory: (_ operationIndex: Int) -> (ChainableOperationBase<I, O>)

    /// Factory for operations' buffers
    private let bufferFactory: OperationBufferFactory = OperationBufferFactoryImplementation()

    /// All operations' buffer (we should hold this property to form result array)
    fileprivate var buffers: [OperationBuffer] = []

    // MARK: - Initializers

    /// Default initializer
    ///
    /// - Parameter operationFactory: closure which describes how we can form our operations for execution
    init(operationFactory: @escaping (_ operationIndex: Int) -> (ChainableOperationBase<I, O>)) {
        self.operationFactory = operationFactory
        super.init()
    }

    // MARK: - ChainableOperationBase

    override public func process(inputData: [I], success: @escaping ([O]) -> (), failure: @escaping (Error) -> ()) {
        let operations = inputData.enumerated().map { (index, data) -> ChainableOperationBase<I, O> in
            let operation = operationFactory(index)
            configureBuffer(for: operation, with: data)
            operation.delegate = self
            return operation
        }
        queue.addOperations(operations, waitUntilFinished: true)
        let output = buffers.compactMap { $0.obtainOperationQueueOutputData() as? O }
        success(output)
    }

    // MARK: - Private

    /// Complete queue's operations
    fileprivate func finishVectorOperationExecution() {
        queue.isSuspended = true
        queue.cancelAllOperations()
        complete()
    }

    /// Configure buffer for the given operation
    ///
    /// - Parameters:
    ///   - operation: some operation
    ///   - inputData: data as input for operation input
    private func configureBuffer(for operation: ChainableOperationBase<I, O>, with inputData: I) {
        let buffer = bufferFactory.createChainableOperationsBuffer()
        buffer.setOperationQueueInputData(inputData)
        operation.input = buffer
        operation.output = buffer
        buffers.append(buffer)
    }
}

// MARK: - ChainableOperationDelegate

extension VectorOperation: ChainableOperationDelegate {

    public func operationSuccess() {
        if buffers.last?.obtainOperationQueueOutputData() != nil {
            finishVectorOperationExecution()
        }
    }

    public func operationFailure(withError error: Error) {
        finishVectorOperationExecution()
        delegate?.operationFailure(withError: error)
    }
}
