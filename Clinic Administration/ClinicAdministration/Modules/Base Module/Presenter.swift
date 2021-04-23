//
//  Presenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

class PresenterInteractor<V: View, I: Interactor> {
    weak var view: V?
    var interactor: I

    init(view: V, interactor: I) {
        self.view = view
        self.interactor = interactor

        if let presenter = self as? V.PresenterType {
            view.presenter = presenter
        } else {
            fatalError("Unrelated view type: \(V.self)")
        }

        if let presenter = self as? I.Delegate {
            interactor.delegate = presenter
        } else {
            fatalError("Unrelated interactor type: \(I.self)")
        }
    }
}

class PresenterView<V: View> {
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
