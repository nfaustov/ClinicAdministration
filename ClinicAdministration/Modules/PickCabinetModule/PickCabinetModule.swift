//
//  PickCabinetModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

protocol PickCabinetModule: AnyObject {
    var didFinish: ((Int?) -> Void)? { get set }
}

protocol PickCabinetView: BaseView { }

protocol PickCabinetPresentation: AnyObject {
    func didFinish(with cabinet: Int?)
}
