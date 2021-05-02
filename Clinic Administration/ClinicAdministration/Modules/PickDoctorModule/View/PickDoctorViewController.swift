//
//  PickDoctorViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

final class PickDoctorViewController: PickerViewController<Doctor> {
    typealias PresenterType = PickDoctorPresentation
    var presenter: PresenterType!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: selectedItem0)
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data[row].secondName + " " + data[row].firstName + " " + data[row].patronymicName
    }
}

// MARK: - PickDoctorDisplaying

extension PickDoctorViewController: PickDoctorDisplaying { }