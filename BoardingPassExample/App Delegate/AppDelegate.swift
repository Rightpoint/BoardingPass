//
//  AppDelegate.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var presenter: BoardingPassPresenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = OnboardingNavigationViewController()
        let viewControllers = [
            FirstViewController(),
            SecondViewController(),
            ThirdViewController(),
            CompletedViewController(),
            ]
        presenter = BoardingPassPresenter(navigationController: navigationController, viewControllersToPresent: viewControllers)
        presenter?.willChangeTopViewController = { topVC in
            if let index = viewControllers.index(of: topVC) {
                navigationController.progress = Progress(completedUnitCount: Int64(index), totalUnitCount: Int64(viewControllers.count) - 1)
            }
        }
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.red
        return true
    }
}

extension AppDelegate: NavigationActionResponder {
    func handleNextTapped(_ sender: UIResponder) {
        presenter?.pushToNextViewController(animated: true)
    }

    func handleSkipTapped(_ sender: UIResponder) {
        guard let last = presenter?.viewControllersToPresent.last else { return }
        presenter?.navigationController.pushViewController(last, animated: true)
    }
}
