//
//  ControlFlowOperationChainer.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - ControlFlowOperationChainer

internal class ControlFlowOperationChainer {
    
    // MARK: - Initializers
        
    /// Initializer
    ///
    /// - Returns: ControlFlowOperationChainer instance
    internal static func controlFlowOperationChainer() -> ControlFlowOperationChainer {
        return ControlFlowOperationChainer()
    }
}

// MARK: - OperationChainer

extension ControlFlowOperationChainer: OperationChainer {
    
    internal func chainOperation<T: AsyncChainableOperation>(_ firstOperation: inout T, withOperation secondOperation: inout T) {
        secondOperation.addDependency(firstOperation)
    }
    
    internal func copy(with zone: NSZone? = nil) -> Any {
        let copy = ControlFlowOperationChainer()
        return copy
    }
}
