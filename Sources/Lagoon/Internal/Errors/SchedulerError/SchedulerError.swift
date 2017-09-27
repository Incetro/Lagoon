//
//  SchedulerError.swift
//  Scheduler
//
//  Created by incetro on 30/03/2017.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - SchedulerError

enum SchedulerError {
    case incorrectBufferData
    case emptyData
}

extension SchedulerError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Buffer's data cannot be empty"
        case .incorrectBufferData:
            return "Invalid buffer's data type"
        }
    }
}
