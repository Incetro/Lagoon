//
//  OperationQueue.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationQueue

internal extension OperationQueue {
    
    // MARK: - Static initializers
    
    /// Create suspended operation queue with maximum concurent operations
    ///
    /// - Returns: OperationQueue instance
    
    static func coo_suspendedOperationQueueWithMaximumConcurentOperations() -> OperationQueue {
        
        return coo_operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: true)
    }
    
    /// Create operation queue with maximum concurent operations
    ///
    /// - Returns: OperationQueue instance
    
    static func coo_operationQueueWithMaximumConcurentOperations() -> OperationQueue {
        
        return coo_operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: false)
    }
    
    /// Create operation queue with maximum concurent operations
    ///
    /// - Parameter isSuspended: suspended bool
    /// - Returns: OperationQueue instance
    
    private static func coo_operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: Bool) -> OperationQueue {
        
        let queue = OperationQueue()
        
        queue.setUniqueQueueName()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.isSuspended = isSuspended
        
        return queue
    }
    
    // MARK: - Internal
    
    private func setUniqueQueueName() {
        
        let coo_uniqueQueueNameFormat = "%@.%@-%@.queue <%@>"
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let className = NSStringFromClass(OperationQueue.self)
        let uuid = UUID().uuidString
        let objectAddress = NSString(format: "%p", self)
        
        self.name = NSString(format: coo_uniqueQueueNameFormat as NSString, bundleIdentifier, className, uuid, objectAddress) as String
    }
}
