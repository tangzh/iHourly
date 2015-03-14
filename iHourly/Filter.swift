//
//  Filter.swift
//  iHourly
//
//  Created by tang on 3/13/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import Foundation

public class Filter {
    var startDateFilter: NSDate?
    var endDateFilter: NSDate?
    
    init() {
        self.startDateFilter = nil
        self.endDateFilter = nil
    }
}