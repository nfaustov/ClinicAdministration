//
//  PatientsSearchModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import Foundation

protocol PatientsSearchModule: AnyObject {
    var didFinish: ((Patient?) -> Void)? { get set }
}

protocol PatientsSearchView: BaseView {
    var resultList: [Patient] { get set }

    func patientsSnapshot(_ patients: [Patient])
}

protocol PatientsSearchPresentation: AnyObject {
    func patientsRequest()
    func performQuery(with text: String)
    func didFinish(with: Patient?)
}

protocol PatientsSearchInteraction: BaseInteractor {
    func getPatients()
}

protocol PatientsSearchInteractorDelegate: AnyObject {
    func patientsDidRecieved(_ patients: [Patient])
}
