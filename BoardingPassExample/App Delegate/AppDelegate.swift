//
//  AppDelegate.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = OnboardingNavigationViewController.sampleOnboarding()
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.red
        return true
    }
}
