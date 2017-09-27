//
//  OperationChainerFactoryImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationChainerFactory

internal class OperationChainerFactoryImplementation {
    
    
}

// MARK: - OperationChainerFactory

extension OperationChainerFactoryImplementation: OperationChainerFactory {
    
    internal func createControlFlowOperationChainer() -> ControlFlowOperationChainer {
        return ControlFlowOperationChainer.controlFlowOperationChainer()
    }
    
    internal func createDataFlowOperationChainer() -> DataFlowOperationChainer {
        return DataFlowOperationChainer.defaultDataFlowOperationChainer()
    }
}
