//
//  CalendarTablePresenter.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import Foundation

final class CalendarTablePresenter<V>: BasePresenter<V>, CalendarTableModule where V: CalendarTableView {
    var didFinish: ((Date?) -> Void)?
}

// MARK: - CalendarTablePresentation

extension CalendarTablePresenter: CalendarTablePresentation {
    func didFinish(with date: Date?) {
        didFinish?(date)
    }
}
