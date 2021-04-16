//
//  File.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import UIKit

final class CalendarRouter {
    let viewController: UIViewController
    weak var output: CalendarRouterOutput!

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - CalendarRouting

extension CalendarRouter: CalendarRouting {
    func dismiss(selectedDate: Date?) {
        if let date = selectedDate {
            output.selectedDate(date)
        } else {
            output.cancelSelection()
        }
    }
}
