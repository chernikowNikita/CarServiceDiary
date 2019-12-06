//
//  AppDelegate.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        let service = OperationService()
        let sceneCoordinator = SceneCoordinator(window: window!)

        let operationListVM = OperationListVM(operationService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.operationList(operationListVM)
        sceneCoordinator.transition(to: firstScene, type: .root)
        return true
    }

}

