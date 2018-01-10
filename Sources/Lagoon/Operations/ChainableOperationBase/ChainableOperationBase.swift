//
//  ChainableOperationBase.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - ChainableOperationBase

open class ChainableOperationBase<I, O>: AsyncChainableOperation {
    
    // MARK: - Operation
    
    override open func main() {
        do {
            if let inputData = try self.obtainInputDataWithClassValidation() as? I {
                self.process(inputData: inputData, success: { processedData in
                    self.processDataSuccess(withData: processedData)
                }, failure: { error in
                    self.processDataFailure(withError: error)
                })
            } else {
                self.processDataFailure(withError: SchedulerError.emptyData)
            }
        } catch {
            self.processDataFailure(withError: error as NSError)
        }
    }
    
    // MARK: - Internal
    
    /// Process input data (you must override this method in your subclasses)
    ///
    /// - Parameters:
    ///   - inputData: operation's input data
    ///   - success: success block
    ///   - failure: failure block
    open func process(inputData: I, success: @escaping (_ processedData: O) -> (), failure: @escaping  (_ error: Error) -> ()) {
        fatalError("You should override the method \(#function) in a subclass")
    }
    
    /// Validate input data
    ///
    /// - Returns: input data for current operation
    /// - Throws: validation error
    private func obtainInputDataWithClassValidation() throws -> Any? {
        return try input?.obtainInputData(withTypeValidationBlock: {
            return $0 is I
        })
    }
    
    /// Data was processed with success
    ///
    /// - Parameter data: output data
    private func processDataSuccess(withData data: O) {
        let outputData = data
        output?.didCompleteChainableOperation(withOutputData: outputData)
        delegate?.operationSuccess()
        complete()
    }
    
    /// Data was processed with failure
    ///
    /// - Parameter error: some error
    private func processDataFailure(withError error: Error) {
        delegate?.operationFailure(withError: error)
        complete()
    }
}
