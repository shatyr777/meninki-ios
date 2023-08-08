//
//  AppDelegate.swift
//  Meninki
//
//  Created by Shirin on 3/28/23.
//

import UIKit
import Localize_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = UINavigationController(rootViewController: getStartVC())
        window?.makeKeyAndVisible()        
        setupLang()
        return true
    }
    
    func getStartVC() -> UIViewController {
        if AccUserDefaults.token.isEmpty {
            return PhoneVC()
        } else {
            return TabbarVC()
        }
    }

    func setupLang(){
        if AccUserDefaults.language.isEmpty {
            AccUserDefaults.language = "ru"
        }

        Localize.setCurrentLanguage(AccUserDefaults.language)
    }
}

