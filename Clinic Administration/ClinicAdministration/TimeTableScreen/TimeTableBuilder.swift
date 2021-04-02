//
//  TimeTableBuilder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit

final class TimeTableBuilder {
    static func build() -> UIViewController {
        let view = TimeTableViewController()
        let router = TimeTableRouter()
        let interactor = TimeTableInteractor()
        let presenter = TimeTablePresenter(view: view, router: router, interactor: interactor)
        view.output = presenter
        interactor.output = presenter

        return view
    }
}
