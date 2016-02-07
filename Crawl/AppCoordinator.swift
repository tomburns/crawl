//
//  AppCoordinator.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let crawlStore: ManagedModelStore<Crawl>

    let mainInterfaceCoordinator: MainInterfaceCoordinator

    init(crawlStore: ManagedModelStore<Crawl> = ManagedModelStore()) {
        self.crawlStore = crawlStore
        self.mainInterfaceCoordinator = MainInterfaceCoordinator(crawlStore: crawlStore)
    }

    func installMainInterface(window window: UIWindow) {
        window.rootViewController = mainInterfaceCoordinator.rootNavController
    }
    
    func applicationWillResignActive(application: UIApplication) {
        crawlStore.save()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        crawlStore.save()
    }
}
