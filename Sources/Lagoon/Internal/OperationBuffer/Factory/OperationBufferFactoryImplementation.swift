//
//  OperationBufferFactoryImplementation.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationBufferFactoryImplementation

internal class OperationBufferFactoryImplementation {

}

// MARK: - OperationBufferFactory

extension OperationBufferFactoryImplementation: OperationBufferFactory {
    
    func createChainableOperationsBuffer() -> OperationBuffer {
        return OperationBufferImplementation()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = OperationBufferFactoryImplementation()
        return copy
    }
}
