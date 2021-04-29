//
//  PickCabinetViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

class PickCabinetViewController: UIViewController {
    typealias PresenterType = PickCabinetPresentation
    var presenter: PresenterType!

    let cabinetPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PickCabinetViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = CustomPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )

        return presentationController
    }
}

// MARK: - PickCabinetDisplaying

extension PickCabinetViewController: PickCabinetDisplaying { }
