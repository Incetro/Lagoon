//
//  OperationBuffersFactory.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationBuffersFactory

internal protocol OperationBuffersFactory: NSCopying {
    
    /// Create buffer
    ///
    /// - Returns: OperationBuffer instance
    
    func createChainableOperationsBuffer() -> OperationBuffer
}
