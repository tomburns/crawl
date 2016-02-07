//
//  CrawlDetailViewController.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

class CrawlDetailViewController: MainInterfaceViewController {
    var crawl: Crawl?

    lazy var viewModel: CrawlDetailViewModel = {
        guard let crawl = self.crawl else {
            fatalError("lol")
        }

        return CrawlDetailViewModel(crawl: crawl)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let foo = viewModel
    }
}


protocol CrawlDetailViewModelType {

}

class CrawlDetailViewModel: CrawlDetailViewModelType {
    var crawl: Crawl

    init(crawl: Crawl) {
        self.crawl = crawl
    }
}
