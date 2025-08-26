//
//  SceneDelegate.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        configureNavAppearance()
        configureTabBarAppearance()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        
        let lottoVC = LottoViewController()
        let boxVC = UINavigationController(rootViewController: BoxOfficeViewController())
        
        lottoVC.tabBarItem = UITabBarItem(title: Constants.UI.Title.lotto, image: Constants.UI.symbolImage.numbers, tag: 1)
        boxVC.tabBarItem = UITabBarItem(title: Constants.UI.Title.boxOffice, image: Constants.UI.symbolImage.movie, tag:2)
        
        
        let isDone = UserDefaults.standard.bool(forKey: Keys.isDone)
        let homeNavVC = UINavigationController()
        homeNavVC.tabBarItem = UITabBarItem(title: Constants.UI.Title.tamagotchi, image: Constants.UI.symbolImage.game, tag: 0)
        
        let homeVC = HomeViewController()
        
        if isDone {
            homeNavVC.setViewControllers([homeVC], animated: false)
        } else {
            let changeVC = ChangeTamagotchiViewController()
            changeVC.title = Constants.UI.Title.selectTG
            homeNavVC.setViewControllers([changeVC], animated: false)
        }
        
        tabBarController.viewControllers = [homeNavVC, lottoVC, boxVC]
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func configureNavAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .tgBlue
        
        UINavigationBar.appearance().tintColor = .tgCyan
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tgBlue
        
        UITabBar.appearance().tintColor = .tgCyan
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension SceneDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backBarButtonItem = UIBarButtonItem(title: Constants.UI.Title.setting, style: .plain, target: nil, action: nil)
        navigationController.topViewController?.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

