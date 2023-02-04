//
//  NetworkServiceDependencies.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.05.2021.
//

import Foundation

protocol NetworkServiceDependencies {
    var doctorService: DoctorService { get }
    var doctorScheduleService: DoctorScheduleService { get }
}
