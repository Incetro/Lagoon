//
//  CompoundOperationQueueOutput.swift
//  Lagoon
//
//  Created by incetro on 20/12/16.
//  Copyright © 2016 Incetro. All rights reserved.
//

import Foundation

// MARK: - CompoundOperationQueueOutput

public protocol CompoundOperationQueueOutput {
    
    /// Returns output data from queue
    ///
    /// - Returns: output data
    func obtainOperationQueueOutputData() -> Any?
}
