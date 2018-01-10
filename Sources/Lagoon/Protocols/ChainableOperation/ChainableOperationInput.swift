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
    /// - Parameter validationBlock: block for input data validation
    /// - Returns: input data
    /// - Throws: validation error
    func obtainInputData(withTypeValidationBlock validationBlock: ChainableOperationInputTypeValidationBlock) throws -> Any
}
