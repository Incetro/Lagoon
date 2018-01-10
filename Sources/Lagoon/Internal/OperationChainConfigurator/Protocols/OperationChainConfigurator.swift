//
//  OperationChainConfigurator.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainConfigurator

internal protocol OperationChainConfigurator: NSCopying {
    
    /// Setup the given operations chain
    ///
    /// - Parameters:
    ///   - chainableOperations: all chainable operations
    ///   - inputData: input data for the given operations chain
    /// - Returns: output buffer
    func configureOperationsChain<T: AsyncChainableOperation>(_ chainableOperations: [T], withInputData inputData: Any) -> OperationBuffer
}
