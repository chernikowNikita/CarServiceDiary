//
//  SceneDelegate.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 05/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let service = OperationService()
        let sceneCoordinator = SceneCoordinator(window: window!)

        let operationListVM = OperationListVM(operationService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.operationList(operationListVM)
        sceneCoordinator.transition(to: firstScene, type: .root)
    }

}

