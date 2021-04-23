//
//  ModulesFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

final class ModulesFactory: Modules {
    func timeTable() -> (UIViewController, TimeTableModule) {
        let view = TimeTableViewController()
        let interactor = TimeTableInteractor()
        let presenter = TimeTablePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule) {
        let view = GraphicTimeTableViewController()
        let interactor = GraphicTimeTableInteractor()
        let presenter = GraphicTimeTablePresenter(view: view, interactor: interactor)
        presenter.didSelected(date: date)

        return (view, presenter)
    }

    func calendar() -> (UIViewController, CalendarModule) {
        let view = CalendarViewController()
        let presenter = CalendarPresenter(view: view)

        return (view, presenter)
    }
}
