//
//  CalendarModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol CalendarModule: AnyObject {
    var didFinish: ((_ date: Date?) -> Void)? { get set }
}

protocol CalendarDisplaying: View { }

protocol CalendarPresentation: AnyObject {
    func didFinish(with date: Date?)
}
