//
//  GraphicTimeTableBuilder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import UIKit

final class GraphicTimeTableBuilder {
    static func build(with date: Date = Date()) -> UIViewController {
        let view = GraphicTimeTableViewController()
        let router = GraphicTimeTableRouter(viewController: view)
        let interactor = GraphicTimeTableInteractor()
        let presenter = GraphicTimeTablePresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        presenter.didSelected(date: date)

        return view
    }
}
