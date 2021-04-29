//
//  PickTimeIntervalViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

class PickTimeIntervalViewController: UIViewController {
    typealias PresenterType = PickTimeIntervalPresentation
    var presenter: PresenterType!

    let intervalPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PickTimeIntervalViewController: UIViewControllerTransitioningDelegate {
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

// MARK: - PickTimeIntervalDisplaying

extension PickTimeIntervalViewController: PickTimeIntervalDisplaying { }
