//
//  SceneDelegate.swift
//  PZXLiveActivities
//
//  Created by pzx on 2023/4/19.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {  () in
            
            print("URL0: \(connectionOptions.urlContexts.first?.url.absoluteString)")

            if (connectionOptions.urlContexts.first?.url.absoluteString == Widget_KEY) {
//                print("URL0: \(connectionOptions.urlContexts.first?.url.absoluteString)")

                NotificationCenter.default.post(name: Notification.Name(Widget_KEY), object: nil)
                
            }
            
        }

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
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget")

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget")

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OpenAppNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpenAppNotification(_:)), name: Notification.Name("OpenAppNotification"), object: nil)
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget")


    }
    
    @objc private func handleOpenAppNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let specialParameter = userInfo["parameter"] as? String {
            // 根据 specialParameter 处理页面跳转逻辑
            print("specialParameter = \(specialParameter)")
            
            DispatchQueue.main.async {
                
                let currentVC = PZXKeyController()
                let newVC = SecondViewController() // 创建要推送的视图控制器
                if let navController = currentVC.navigationController {
                    navController.pushViewController(newVC, animated: true)
                }
                
            }
            
            
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget")

    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //            print("URLContexts: \(URLContexts)")
        if let urlString = URLContexts.first?.url.absoluteString.removingPercentEncoding {
            print("URL1: \(urlString)")
        } else {
            print("Failed to decode the URL")
        }
        
        if (URLContexts.first!.url.absoluteString == Widget_KEY) {
            print("URL1: \(URLContexts.first!.url)")
            NotificationCenter.default.post(name: Notification.Name(Widget_KEY), object: nil)
        }
        
        
    }

    
}

