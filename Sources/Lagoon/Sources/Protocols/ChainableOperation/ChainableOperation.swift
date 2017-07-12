//
//  ChainableOperation.swift
//  Scheduler
//
//  Created by incetro on 26/05/2017.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - ChainableOperation

public protocol ChainableOperation {
    
    var delegate: ChainableOperationDelegate? { get set }
    
    var input: ChainableOperationInput? { get set }
    
    var output: ChainableOperationOutput? { get set }
}
