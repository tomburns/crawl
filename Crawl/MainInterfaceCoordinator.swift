//
//  MainInterfaceCoordinator.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit


// Passed between View Controllers for creation of view models
class MainInterfaceDependencies {
    let crawlStore: ManagedModelStore<Crawl>
    
    init(crawlStore: ManagedModelStore<Crawl>) {
        self.crawlStore = crawlStore
    }
}

class MainInterfaceViewController: UIViewController {
    var dependencies: MainInterfaceDependencies!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? MainInterfaceViewController {
            destination.dependencies = self.dependencies
        } else if let destination = segue.destinationViewController as? UINavigationController,
            let destinationRoot = destination.viewControllers[0] as? MainInterfaceViewController {
                destinationRoot.dependencies = self.dependencies
        }
    }
}


class MainInterfaceCoordinator {
    
    let rootNavController: UINavigationController
    
    let crawlListVC: CrawlListViewController
    
    static let dependencies: MainInterfaceDependencies = MainInterfaceDependencies(crawlStore: ManagedModelStore<Crawl>())
    
    init(crawlStore: ManagedModelStore<Crawl>) {
        
        let rootNavController = Storyboards.Main.instantiateInitialViewController()
        
        guard let crawlListVC = rootNavController.viewControllers[0] as? CrawlListViewController else {
            fatalError("Unexpected view controller arrangement in Main storyboard")
        }
        
        self.rootNavController = rootNavController
        self.crawlListVC = crawlListVC
    }
}