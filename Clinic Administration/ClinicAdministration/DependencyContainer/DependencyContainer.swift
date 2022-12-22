//
//  DependencyContainer.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.05.2021.
//

import Foundation

final class DependencyContainer: DatabaseDependencies, NetworkServiceDependencies {
    // MARK: - Database

    lazy var doctorsDatabase = DoctorDatabase()

    // MARK: - NetworkService

    lazy var doctorService: DoctorService = DoctorServiceClient()
}
