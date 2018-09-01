//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Emil Marashliev on 28.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit
import RxCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    var coordinator: BasicCoordinator<MainRoute>!

	func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        coordinator = BasicCoordinator<MainRoute>(initialRoute: .home, initialLoadingType: .immediately)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
        self.window = window

		return true
	}
}

