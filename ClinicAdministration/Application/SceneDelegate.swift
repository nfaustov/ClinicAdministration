//
//  SceneDelegate.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        let dependencies: DatabaseDependencies & NetworkServiceDependencies = DependencyContainer()
        let modules = ModulesFactory(dependencies: dependencies)
        coordinator = MainCoordinator(navigationController: navigationController, modules: modules)
        coordinator?.patientCoordinator()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let database = DoctorDatabase()
        database.saveContext()
    }
}
