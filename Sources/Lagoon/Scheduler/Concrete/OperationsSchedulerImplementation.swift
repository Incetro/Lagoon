//
//  OperationsSchedulerImplementation.swift
//  Lagoon
//
//  Created by incetro on 19/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - OperationsSchedulerImplementation

public class OperationsSchedulerImplementation {
    
    // MARK: - Properties
    
    internal static let queueName = "incetro.scheduler.queue"
    
    /// Main queue
    private(set) var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = OperationsSchedulerImplementation.queueName
        queue.isSuspended = false
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        return queue
    }()
    
    // MARK: - Inititalizers
    
    public init() {

    }

    /// OperationQueue initializer
    ///
    /// - Parameter queue: target queue for all aoperations
    public init(queue: OperationQueue) {
        self.queue = queue
    }
    
    // MARK: - Static initializers
    
    static func defaultScheduler() -> OperationsSchedulerImplementation {
        let scheduler = OperationsSchedulerImplementation()
        return scheduler
    }
}

// MARK: - OperationsScheduler

extension OperationsSchedulerImplementation: OperationsScheduler {
    
    public func add(operation: Operation) {
        queue.addOperation(operation)
    }
    
    public func setMaxConcurrentOperationCount(_ count: Int) {
        queue.maxConcurrentOperationCount = count
    }
}
