//
//  OperationChainersFactoryImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainerFactory

internal class OperationChainersFactoryImplementation {
    
    
}

// MARK: - OperationChainerFactory

extension OperationChainersFactoryImplementation: OperationChainersFactory {
    
    internal func createControlFlowOperationChainer() -> ControlFlowOperationChainer {
        
        return ControlFlowOperationChainer.controlFlowOperationChainer()
    }
    
    internal func createDataFlowOperationChainer() -> DataFlowOperationChainer {
        
        return DataFlowOperationChainer.defaultDataFlowOperationChainer()
    }
}
