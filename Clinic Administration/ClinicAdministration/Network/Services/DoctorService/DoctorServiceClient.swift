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
        let endpoint = DoctorEndpoint.index

        return networkController.get(
            type: [Doctor].self,
            url: endpoint.url,
            headers: endpoint.headers
        )
    }

    func createDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error> {
        let endpoint = DoctorEndpoint.create(doctor)

        return networkController.post(
            type: Doctor.self,
            url: endpoint.url,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }

    func getDoctor(id: UUID) -> AnyPublisher<Doctor, Error> {
        let endpoint = DoctorEndpoint.doctor(id)

        return networkController.get(
            type: Doctor.self,
            url: endpoint.url,
            headers: endpoint.headers
        )
    }

    func updateDoctor(_ doctor: Doctor) -> AnyPublisher<Doctor, Error> {
        let endpoint = DoctorEndpoint.update(doctor)

        return networkController.put(
            type: Doctor.self,
            url: endpoint.url,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }

    func deleteDoctor(id: UUID) -> AnyPublisher<Doctor, Error> {
        let endpoint = DoctorEndpoint.doctor(id)

        return networkController.delete(
            type: Doctor.self,
            url: endpoint.url,
            headers: endpoint.headers
        )
    }
}
