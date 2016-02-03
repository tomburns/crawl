//
//  MainInterfaceCoordinator.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit


class MainInterfaceCoordinator {

    let rootNavController: UINavigationController

    let crawlListVC: CrawlListViewController

    let crawlStore: CrawlStoreType

    init(crawlStore: CrawlStoreType) {

        let rootNavController = Storyboards.Main.instantiateInitialViewController()

        guard let crawlListVC = rootNavController.viewControllers[0] as? CrawlListViewController else {
            fatalError("Unexpected view controller arrangement in Main storyboard")
        }

        self.rootNavController = rootNavController
        self.crawlListVC = crawlListVC

        self.crawlStore = crawlStore
    }

    func showDetailForCrawl(crawl: Crawl) {

        let detailViewController = Storyboards.Main.instantiateCrawlDetail()

        let segueIdentifier = CrawlListViewController.Segue.ShowCrawlDetailFromList.identifier
        let segue = UIStoryboardSegue(identifier: segueIdentifier, source: crawlListVC, destination: detailViewController)

        rootNavController.popToViewController(crawlListVC, animated: true)
        crawlListVC.performSegue(segue)
    }
}