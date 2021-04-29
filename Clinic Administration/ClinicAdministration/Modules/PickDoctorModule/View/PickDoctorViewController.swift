//
//  PickDoctorViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

final class PickDoctorViewController: UIViewController {
    typealias PresenterType = PickDoctorPresentation
    var presenter: PresenterType!

    let doctorPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PickDoctorViewController: UIViewControllerTransitioningDelegate {
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

// MARK: - PickDoctorDisplaying

extension PickDoctorViewController: PickDoctorDisplaying { }
