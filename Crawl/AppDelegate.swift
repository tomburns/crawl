//
//  AppDelegate.swift
//  Crawl
//
//  Created by Tom Burns on 1/31/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit
import RxSwift
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    var appCoordinator: AppCoordinator!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        appCoordinator = AppCoordinator()

        if let window = window {
            appCoordinator.installMainInterface(window: window)
        }

        return true
    }
}