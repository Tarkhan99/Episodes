//
//  SceneDelegate.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let networkClient = EpisodesNetworkClient()
        let episodesVM = EpisodesViewModel(networkClient: networkClient)
        let episodesVC = EpisodesViewController(viewModel: episodesVM)
        
        let navController = UINavigationController(rootViewController: episodesVC)
        navController.navigationBar.isTranslucent = false
        
        window.rootViewController = navController
        
        window.backgroundColor = .secondarySystemBackground
        self.window = window
        window.makeKeyAndVisible()
    }

}

