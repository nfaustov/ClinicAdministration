//
//  PickCabinetViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

final class PickCabinetViewController: PickerViewController<Int> {
    typealias PresenterType = PickCabinetPresentation
    var presenter: PresenterType!

    var selectedCabinet: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        (1...Settings.cabinets).forEach { data.append($0) }

        if let cabinet = selectedCabinet {
            previouslyPicked(cabinet)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: selectedItem0)
    }
}

// MARK: - PickCabinetView

extension PickCabinetViewController: PickCabinetView { }
