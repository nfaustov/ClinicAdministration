//
//  PickDoctorModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

protocol PickDoctorModule: AnyObject {
    var didFinish: ((Doctor?) -> Void)? { get set }
}

protocol PickDoctorDisplaying: View { }

protocol PickDoctorPresentation: AnyObject {
    func didFinish(with doctor: Doctor?)
}
