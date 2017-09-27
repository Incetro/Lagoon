//
//  OperationQueue.swift
//  Lagoon
//
//  Created by incetro on 18/01/17.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationQueue

public extension OperationQueue {
    
    // MARK: - Static initializers
    
    /// Create suspended operation queue with maximum concurent operations
    ///
    /// - Returns: OperationQueue instance
    static func suspendedOperationQueueWithMaximumConcurentOperations() -> OperationQueue {
        return operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: true)
    }
    
    /// Create operation queue with maximum concurent operations
    ///
    /// - Returns: OperationQueue instance
    static func operationQueueWithMaximumConcurentOperations() -> OperationQueue {
        return operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: false)
    }
    
    /// Create operation queue with maximum concurent operations
    ///
    /// - Parameter isSuspended: suspended bool
    /// - Returns: OperationQueue instance
    private static func operationQueueWithMaximumConcurentOperationsAndSuspendedState(isSuspended: Bool) -> OperationQueue {
        let queue = OperationQueue()
        queue.setUniqueQueueName()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.isSuspended = isSuspended
        return queue
    }
    
    // MARK: - Internal
    
    private func setUniqueQueueName() {
        let uniqueQueueNameFormat = "%@.%@-%@.queue <%@>"
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let className = NSStringFromClass(OperationQueue.self)
        let uuid = UUID().uuidString
        let objectAddress = NSString(format: "%p", self)
        self.name = NSString(format: uniqueQueueNameFormat as NSString, bundleIdentifier, className, uuid, objectAddress) as String
    }
}
