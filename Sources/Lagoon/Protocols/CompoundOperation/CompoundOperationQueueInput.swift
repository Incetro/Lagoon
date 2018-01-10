//
//  CompoundOperationQueueInput.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - CompoundOperationQueueInput

public protocol CompoundOperationQueueInput {
    
    /// Set input data for operations queue
    ///
    /// - Parameter data: input data for queue
    func setOperationQueueInputData(_ data: Any)
}
