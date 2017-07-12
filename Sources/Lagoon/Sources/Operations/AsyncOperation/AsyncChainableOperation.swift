//
//  AsyncChainableOperation.swift
//  Scheduler
//
//  Created by incetro on 26/05/2017.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - AsyncChainableOperation

open class AsyncChainableOperation: AsyncOperation, ChainableOperation {
    
    // MARK: - Properties
    
    public var delegate: ChainableOperationDelegate?
    
    public var input: ChainableOperationInput?
    
    public var output: ChainableOperationOutput?
}
