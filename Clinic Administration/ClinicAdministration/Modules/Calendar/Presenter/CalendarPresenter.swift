//
//  CalendarPresenter.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import Foundation

final class CalendarPresenter {
    var router: CalendarRouting!

    init(router: CalendarRouting) {
        self.router = router
    }
}

// MARK: - CalendarPresentation

extension CalendarPresenter: CalendarPresentation {
    func exit(with date: Date?) {
        if let date = date {
            router.dismiss(selectedDate: date)
        } else {
            router.dismiss(selectedDate: nil)
        }
    }
}
