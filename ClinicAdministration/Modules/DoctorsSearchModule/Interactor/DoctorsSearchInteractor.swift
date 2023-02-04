//
//  DoctorsSearchInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation
import Combine

final class DoctorsSearchInteractor {
    typealias Delegate = DoctorsSearchInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorService: DoctorService?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - DoctorsSearchInteraction

extension DoctorsSearchInteractor: DoctorsSearchInteraction {
//    func getDoctors() {
//        guard let doctorsEntities = database?.read() else { return }
//
//        let doctors = doctorsEntities.compactMap { Doctor(entity: $0) }
//        delegate?.doctorsDidRecieved(doctors)
//    }

    func getDoctors() {
        doctorService?.getAllDoctors()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [delegate] doctors in
                delegate?.doctorsDidRecieved(doctors)
            })
            .store(in: &subscriptions)
    }
}
