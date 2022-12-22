//
//  HttpServiceDependencies.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.05.2021.
//

import Foundation

protocol HttpServiceDependencies {
    var doctorService: DoctorService { get }
}
