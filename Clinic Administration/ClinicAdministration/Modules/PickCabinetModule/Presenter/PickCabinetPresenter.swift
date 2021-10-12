//
//  PickCabinetPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

final class PickCabinetPresenter<V>: Presenter<V>, PickCabinetModule where V: PickCabinetDisplaying {
    var didFinish: ((Int?) -> Void)?
}

// MARK: - PickCabinetPresentation

extension PickCabinetPresenter: PickCabinetPresentation {
    func didFinish(with cabinet: Int?) {
        didFinish?(cabinet)
    }
}
