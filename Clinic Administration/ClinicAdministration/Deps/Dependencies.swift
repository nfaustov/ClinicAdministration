//
//  Dependencies.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.05.2021.
//

import Foundation

final class Dependencies: DatabaseDependencies, HttpServiceDependencies {
    // MARK: - Database

    lazy var doctorsDatabase = DoctorsDatabase()

    // MARK: - HttpService
}
