//
//  CalendarRouterOutput.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import Foundation

public protocol CalendarRouterOutput: AnyObject {
    func selectedDate(_ date: Date)

    func cancelSelection()
}
