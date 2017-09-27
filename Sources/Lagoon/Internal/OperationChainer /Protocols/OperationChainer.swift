//
//  OperationChainer.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainer

internal protocol OperationChainer: NSCopying {
    
    /// Chain 2 opertions
    ///
    /// - Parameters:
    ///   - firstOperation: independent operation
    ///   - secondOperation: dependent opertaion
    func chainOperation<T: AsyncChainableOperation>(_ firstOperation: inout T, withOperation secondOperation: inout T)
}
