//
//  CalendarBuilder.swift
//  
//
//  Created by Nikolai Faustov on 15.04.2021.
//

import UIKit

final class CalendarBuilder {
    static func build(delegate: CalendarRouterOutput) -> UIViewController {
        let view = CalendarViewController()
        let router = CalendarRouter(viewController: view)
        let presenter = CalendarPresenter(router: router)
        view.presenter = presenter
        router.output = delegate

        return view
    }
}
