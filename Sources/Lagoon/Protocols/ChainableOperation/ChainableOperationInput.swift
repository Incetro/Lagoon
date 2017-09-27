//
//  ChainableOperationInput.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

public typealias ChainableOperationInputTypeValidationBlock = (_ data: Any) -> Bool

// MARK: - ChainableOperationInput

public protocol ChainableOperationInput {
    
    /// Obtain input data
    ///
    /// - Parameter validationBlock: Block which validates input data
    /// - Returns: input data
    /// - Throws: Validation error
    func obtainInputData(withTypeValidationBlock validationBlock: ChainableOperationInputTypeValidationBlock) throws -> Any
}
