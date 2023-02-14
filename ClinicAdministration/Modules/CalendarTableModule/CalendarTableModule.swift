//
//  CalendarTableModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol CalendarTableModule: AnyObject {
    var didFinish: ((_ date: Date?) -> Void)? { get set }
}

protocol CalendarTableView: BaseView { }

protocol CalendarTablePresentation: AnyObject {
    func didFinish(with date: Date?)
}
