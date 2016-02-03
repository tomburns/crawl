//
//  AppCoordinator.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let crawlStore: CrawlStoreType

    let mainInterfaceCoordinator: MainInterfaceCoordinator

    init(crawlStore: CrawlStoreType = CrawlStore()) {
        self.crawlStore = crawlStore
        self.mainInterfaceCoordinator = MainInterfaceCoordinator(crawlStore: crawlStore)
    }

    func installMainInterface(window window: UIWindow) {
        window.rootViewController = mainInterfaceCoordinator.rootNavController
    }
}
