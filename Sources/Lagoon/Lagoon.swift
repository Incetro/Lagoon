//
//  Lagoon.swift
//  Lagoon
//
//  Created by incetro on 11/07/2017.
//
//

import Foundation

// MARK: - Lagoon

public class Lagoon {
    
    /// Singleton
    static let instance = Lagoon()
    
    /// Scheduler with operations
    private let scheduler: OperationsScheduler = OperationsSchedulerImplementation()
    
    /// Add new operation
    ///
    /// - Parameter operation: new operation
    private func add(_ operation: Operation) {
        scheduler.addOperation(operation)
    }
    
    /// Add new operation
    ///
    /// - Parameter operation: new operation
    public static func add(operation: Operation) {
        instance.add(operation)
    }
}
