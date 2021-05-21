//
//  CalendarPresenter.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import Foundation

final class CalendarPresenter<V>: PresenterView<V>, CalendarModule where V: CalendarDisplaying {
    var didFinish: ((Date?) -> Void)?
}

// MARK: - CalendarPresentation

extension CalendarPresenter: CalendarPresentation {
    func didFinish(with date: Date?) {
        didFinish?(date)
    }
}
