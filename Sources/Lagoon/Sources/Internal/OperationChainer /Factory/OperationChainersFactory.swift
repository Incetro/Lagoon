//
//  OperationChainerFactory.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainerFactory

internal protocol OperationChainersFactory {
    
    /// Creates ControlFlowOperationChainer instance
    ///
    /// - Returns: ControlFlowOperationChainer instance
    
    func createControlFlowOperationChainer() -> ControlFlowOperationChainer
    
    /// Creates DataFlowOperationChainer instance
    ///
    /// - Returns: DataFlowOperationChainer instance
    
    func createDataFlowOperationChainer() -> DataFlowOperationChainer
}
