//
//  DoctorsSearchModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation

protocol DoctorsSearchModule: AnyObject {
    var didFinish: ((Doctor?) -> Void)? { get set }
}

protocol DoctorsSearchView: View {
    var resultList: [Doctor] { get set }

    func doctorsSnapshot(_ doctors: [Doctor])
}

protocol DoctorsSearchPresentation: AnyObject {
    func doctorsRequest()
    func performQuery(with text: String, specialization: String?)
    func didFinish(with: Doctor?)
}

protocol DoctorsSearchInteraction: Interactor {
    func getDoctors()
}

protocol DoctorsSearchInteractorDelegate: AnyObject {
    func doctorsDidRecieved(_ doctors: [Doctor])
}
