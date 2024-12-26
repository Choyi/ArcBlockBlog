//
//  SceneDelegate.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let blogListVC = BlogListViewController()
        let navigationController = UINavigationController(rootViewController: blogListVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
