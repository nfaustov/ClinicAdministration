//
//  DoctorService.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import Foundation
import Combine

protocol DoctorService: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func getAllDoctors() -> AnyPublisher<[Doctor], Error>
    func createDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error>
    func getDoctor(id: UUID?) -> AnyPublisher<Doctor, Error>
    func updateDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error>
    func deleteDoctor(id: UUID?) -> AnyPublisher<Bool, Error>
}
