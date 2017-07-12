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
    
    fileprivate var bufferFactory: OperationBuffersFactory
    
    /// Private initializer
    ///
    /// - Parameter bufferFactory: Buffers' factory
    
    fileprivate init(withBufferFactory bufferFactory: OperationBuffersFactory) {
        
        self.bufferFactory = bufferFactory
    }
    
    // MARK: - Static initializers
    
    /// Initializer
    ///
    /// - Parameter bufferFactory: Buffers' factory
    /// - Returns: DataFlowOperationChainer instance
    
    internal static func dataFlowOperationChainer(withBufferFactory bufferFactory: OperationBuffersFactory) -> DataFlowOperationChainer {
        
        return DataFlowOperationChainer(withBufferFactory: bufferFactory)
    }
    
    /// Default initializer
    ///
    /// - Returns: DataFlowOperationChainer instance
    
    internal static func defaultDataFlowOperationChainer() -> DataFlowOperationChainer {
        
        let bufferFactory = OperationBuffersFactoryImplementation()
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
        
        guard let bufferFactory = self.bufferFactory.copy(with: nil) as? OperationBuffersFactory else {
            
            fatalError()
        }
        
        let copy = DataFlowOperationChainer(withBufferFactory: bufferFactory)
        
        return copy
    }
}
