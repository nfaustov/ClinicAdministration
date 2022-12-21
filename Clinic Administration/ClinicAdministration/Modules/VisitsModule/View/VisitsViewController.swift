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

        let headerView = VisitsHeaderView()
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: - VisitsView

extension VisitsViewController: VisitsView {
}
