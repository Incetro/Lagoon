//
//  Lagoon.swift
//  Lagoon
//
//  Created by incetro on 11/07/2017.
//
//

import Foundation

// MARK: - OperationsScheduler

public protocol OperationsScheduler {
    
    /// Add new operation
    ///
    /// - Parameter operation: New operation
    
    func addOperation(_ operation: Operation)
    
    /// Set max concurrent operations count
    ///
    /// - Parameter count: max concurrent operations count
    
    func setMaxConcurrentOperationCount(_ count: Int)
}
