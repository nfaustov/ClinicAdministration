//
//  VisitsViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import UIKit

final class VisitsViewController: UIViewController {
    typealias PresneterType = VisitsPresentation
    var presenter: PresneterType!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - VisitsView

extension VisitsViewController: VisitsView {
}
