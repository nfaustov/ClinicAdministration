//
//  PickTimeIntervalPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

final class PickTimeIntervalPresenter<V>: Presenter<V>, PickTimeIntervalModule where V: PickTimeIntervalDisplaying {
    var didFinish: ((Date?, Date?) -> Void)?
}

// MARK: - PickTimeIntervalPresentation

extension PickTimeIntervalPresenter: PickTimeIntervalPresentation {
    func didFinish(with interval: (Date?, Date?)) {
        didFinish?(interval.0, interval.1)
    }
}
