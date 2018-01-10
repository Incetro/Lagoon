//
//  OperationBufferImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationBufferImplementation

internal class OperationBufferImplementation {
    
    // MARK: - Properties
    
    /// Buffer's data
    private var buffer: Any?
    
    // MARK: - Internal
    
    /// Update current data
    ///
    /// - Parameter data: new data
    private func updateBuffer(withData data: Any) {
        buffer = data
    }
    
    /// Get data from the current buffer
    ///
    /// - Returns: current data
    private func obtainBufferData() -> Any? {
        return buffer
    }
    
    /// Get data from the current buffer with validation
    ///
    /// - Parameter validationBlock: block which validates buffer's data
    /// - Returns: current data
    /// - Throws: validation error
    private func obtainBufferData(withValidationBlock validationBlock: ChainableOperationInputTypeValidationBlock) throws -> Any {
        
        guard let data = self.obtainBufferData() else {
            throw SchedulerError.emptyData
        }
        
        let isBufferContentValid = validationBlock(data)
        
        if !isBufferContentValid {
            throw SchedulerError.incorrectBufferData
        }
        
        return data
    }
}

// MARK: - OperationBuffer

extension OperationBufferImplementation: OperationBuffer {
    
    func obtainInputData(withTypeValidationBlock validationBlock: ChainableOperationInputTypeValidationBlock) throws -> Any {
        return try obtainBufferData(withValidationBlock: validationBlock)
    }
    
    func didCompleteChainableOperation(withOutputData data: Any) {
        updateBuffer(withData: data)
    }
    
    func setOperationQueueInputData(_ data: Any) {
        updateBuffer(withData: data)
    }
    
    func obtainOperationQueueOutputData() -> Any? {
        return buffer
    }
}
