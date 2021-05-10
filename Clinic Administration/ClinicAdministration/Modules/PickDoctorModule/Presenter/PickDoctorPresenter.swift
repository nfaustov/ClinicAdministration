//
//  PickDoctorPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

final class PickDoctorPresenter<V>: PresenterView<V>, PickDoctorModule where V: PickDoctorDisplaying {
    var didFinish: ((Doctor?) -> Void)?
}

// MARK: - PickDoctorPresentation

extension PickDoctorPresenter: PickDoctorPresentation {
    func didFinish(with doctor: Doctor?) {
        didFinish?(doctor)
    }
}
