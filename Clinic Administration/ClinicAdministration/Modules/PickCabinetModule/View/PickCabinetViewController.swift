//
//  PickCabinetViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

class PickCabinetViewController: PickerViewController<Int> {
    typealias PresenterType = PickCabinetPresentation
    var presenter: PresenterType!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: selectedItem0)
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(data[row])"
    }
}

// MARK: - PickCabinetDisplaying

extension PickCabinetViewController: PickCabinetDisplaying { }
