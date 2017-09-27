//
//  DataFlowOperationChainer.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - DataFlowOperationChainer

internal class DataFlowOperationChainer {
    
    // MARK: - Properties
    
    /// Buffers' factory
    
    fileprivate var bufferFactory: OperationBufferFactory
    
    /// Private initializer
    ///
    /// - Parameter bufferFactory: Buffers' factory
    fileprivate init(withBufferFactory bufferFactory: OperationBufferFactory) {
        self.bufferFactory = bufferFactory
    }
    
    // MARK: - Static initializers
    
    /// Initializer
    ///
    /// - Parameter bufferFactory: Buffers' factory
    /// - Returns: DataFlowOperationChainer instance
    internal static func dataFlowOperationChainer(withBufferFactory bufferFactory: OperationBufferFactory) -> DataFlowOperationChainer {
        return DataFlowOperationChainer(withBufferFactory: bufferFactory)
    }
    
    /// Default initializer
    ///
    /// - Returns: DataFlowOperationChainer instanc
    internal static func defaultDataFlowOperationChainer() -> DataFlowOperationChainer {
        let bufferFactory = OperationBufferFactoryImplementation()
        return DataFlowOperationChainer(withBufferFactory: bufferFactory)
    }
}

// MARK: - OpeationChainer

extension DataFlowOperationChainer: OperationChainer {
    
    internal func chainOperation<T: AsyncChainableOperation>(_ firstOperation: inout T, withOperation secondOperation: inout T) {
        
        secondOperation.addDependency(firstOperation)

        let buffer = bufferFactory.createChainableOperationsBuffer()
        
        firstOperation.output = buffer
        secondOperation.input = buffer
    }
    
    internal func copy(with zone: NSZone? = nil) -> Any {
        
        guard let bufferFactory = bufferFactory.copy(with: nil) as? OperationBufferFactory else {
            fatalError()
        }
        
        return DataFlowOperationChainer(withBufferFactory: bufferFactory)
    }
}
