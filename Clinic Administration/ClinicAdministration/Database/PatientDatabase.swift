//
//  PatientDatabase.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.12.2022.
//

import Foundation
import CoreData

final class PatientDatabase: Database {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PatientModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Mock data

    //
    //
    //

    // MARK: - Create

    func create(objectWithModel: Patient) {
    }

    // MARK: - Read

    func read() -> [PatientEntity] {
        []
    }

    // MARK: - Update

    func update(changes: (() -> Void)?) {
        changes?()

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }

    // MARK: - Delete

    func delete(object: PatientEntity) {
    }
}
