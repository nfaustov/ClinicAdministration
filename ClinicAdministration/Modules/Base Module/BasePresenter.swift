//
//  BasePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

class BasePresenter<V: BaseView> {
    weak var view: V?

    init(view: V) {
        self.view = view

        if let presenter = self as? V.PresenterType {
            view.presenter = presenter
        } else {
            fatalError("Unrelated view type: \(V.self)")
        }
    }
}

class PresenterInteractor<V: BaseView, I: BaseInteractor>: BasePresenter<V> {
    var interactor: I

    init(view: V, interactor: I) {
        self.interactor = interactor
        super.init(view: view)

        if let presenter = self as? I.Delegate {
            interactor.delegate = presenter
        } else {
            fatalError("Unrelated interactor type: \(I.self)")
        }
    }
}
