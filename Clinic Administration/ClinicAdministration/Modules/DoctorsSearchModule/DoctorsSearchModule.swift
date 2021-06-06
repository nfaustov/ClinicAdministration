//
//  DoctorsSearchModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation

protocol DoctorsSearchModule: AnyObject {
    var coordinator: DoctorsSearchCoordinator? { get set }
    var didFinish: ((Doctor) -> Void)? { get set }
}

protocol DoctorsSearchDisplaying: View {
    var doctorsList: [Doctor] { get set }

    func doctorsSnapshot(_ doctors: [Doctor])
}

protocol DoctorsSearchPresentation: AnyObject {
    func doctorsRequest()
    func performQuery(with filter: String)
    func didFinish(with doctor: Doctor)
}

protocol DoctorsSearchInteraction: Interactor {
    func getDoctors()
}

protocol DoctorsSearchInteractorDelegate: AnyObject {
    func doctorsDidRecieved(_ doctors: [Doctor])
}
