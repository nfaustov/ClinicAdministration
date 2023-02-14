//
//  AdminPanelViewController.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import UIKit

final class AdminPanelViewController: UIViewController {
    typealias PresenterType = AdminPanelPresentation
    var presenter: PresenterType!
}

// MARK: - AdminPanelView

extension AdminPanelViewController: AdminPanelView {
}
