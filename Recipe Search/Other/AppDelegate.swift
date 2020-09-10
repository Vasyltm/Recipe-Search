//
//  AppDelegate.swift
//  Recipe Search
//
//  Created by Vasyl Travlinskyy on 08.09.2020.
//  Copyright © 2020 Vasyl Travlinskyy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let splitViewController = UISplitViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootNavigationController()
        return true
    }
    
    
    
    func setRootNavigationController() {
        
        splitViewController.delegate = self
        let masterNavigationController = UINavigationController(rootViewController: RecipeSearch())
        let detailNavigationController = UINavigationController(rootViewController: RecipeDetails())
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        window?.rootViewController = Main()
        window?.backgroundColor = Color.background
        window?.makeKeyAndVisible()
    }

    
}



extension AppDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
    
    
    
}
