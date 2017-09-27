//
//  AsyncOperation.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - AsyncOperation

open class AsyncOperation: Operation {
    
    // MARK: - Properties
    
    private struct Execution {
        var executing: Bool = false
        var finished:  Bool = false
    }
    
    private var execution = Execution(executing: false, finished: false)
    
    private struct Flag {

        /// `isExecuting` flag
        static let isExecuting = "isExecuting"
        
        /// `isFinished` flag
        static let isFinished  = "isFinished"
    }
    
    // MARK: - Operation
    
    override open var isExecuting: Bool {
        return execution.executing
    }
    
    override open var isFinished: Bool {
        return execution.finished
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        
        if isCancelled {
            complete()
            return
        } else if self.isReady {
            willChangeValue(forKey: Flag.isExecuting)
            Thread.detachNewThreadSelector(#selector(main), toTarget: self, with: nil)
            execution.executing = true
            didChangeValue(forKey: Flag.isExecuting)
        }
    }
    
    // MARK: - Internal
    
    internal func complete() {
        
        willChangeValue(forKey: Flag.isExecuting)
        willChangeValue(forKey: Flag.isFinished)
        
        execution.executing = false
        execution.finished  = true
        
        didChangeValue(forKey: Flag.isFinished)
        didChangeValue(forKey: Flag.isExecuting)
    }
}
