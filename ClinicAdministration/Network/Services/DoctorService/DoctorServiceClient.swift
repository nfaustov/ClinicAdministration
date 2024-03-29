//
//  DoctorServiceClient.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import Foundation
import Combine

final class DoctorServiceClient: DoctorService {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func getAllDoctors() -> AnyPublisher<[Doctor], Error> {
        networkController.request(
            method: .get,
            endpoint: DoctorEndpoint.doctors
        )
    }

    func createDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error> {
        networkController.request(
            method: .post,
            endpoint: DoctorEndpoint.create(doctor)
        )
    }

    func getDoctor(id: UUID?) -> AnyPublisher<Doctor, Error> {
        networkController.request(
            method: .get,
            endpoint: DoctorEndpoint.doctor(id)
        )
    }

    func updateDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error> {
        networkController.request(
            method: .put,
            endpoint: DoctorEndpoint.update(doctor)
        )
    }

    func deleteDoctor(id: UUID?) -> AnyPublisher<Bool, Error> {
        networkController.deleteRequest(endpoint: DoctorEndpoint.doctor(id))
    }
}
