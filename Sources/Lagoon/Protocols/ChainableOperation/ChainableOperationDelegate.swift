//
//  ChainableOperationDelegate.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - ChainableOperationDelegate

public protocol ChainableOperationDelegate {
    
    /// Operation was finished success
    func operationSuccess()
    
    /// Current operation was interrupted with error
    ///
    /// - Parameter error: operation error
    func operationFailure(withError error: Error)
}
