//
//  ChainableOperationOutput.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - ChainableOperationOutput

public protocol ChainableOperationOutput {
    
    /// Operation was completed
    ///
    /// - Parameter data: output data
    func didCompleteChainableOperation(withOutputData data: Any)
}
