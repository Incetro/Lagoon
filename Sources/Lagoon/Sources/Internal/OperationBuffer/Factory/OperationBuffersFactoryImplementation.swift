//
//  OperationBuffersFactoryImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationBuffersFactoryImplementation

internal class OperationBuffersFactoryImplementation {
    
    
}

// MARK: - OperationBuffersFactory

extension OperationBuffersFactoryImplementation: OperationBuffersFactory {
    
    func createChainableOperationsBuffer() -> OperationBuffer {
        
        return OperationBufferImplementation()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = OperationBuffersFactoryImplementation()
        
        return copy
    }
}
