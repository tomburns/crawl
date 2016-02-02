//
//  CrawlListViewModel.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import RxDataSources
import RxCocoa
import RxSwift

struct CrawlListViewModel {

    let store = CrawlStore()

    let sections: Driver<[CrawlSection]>


    init(crawlStore: CrawlStore = CrawlStore()) {
        self.sections = store.allCrawls()
            .map { crawls in
                return [CrawlSection(items: crawls)]
            }
            .asDriver(onErrorJustReturn:[])

    }
}

//Mark: Identity, etc


extension Crawl: IdentifiableType {
    typealias Identity = Int

    var identity: Identity { return self.hashValue }
}

extension CrawlSection: IdentifiableType {
    typealias Identity = String

    var identity: Identity { return self.title }
}


struct CrawlSection: AnimatableSectionModelType {
    typealias Item = Crawl
    let items: [Crawl]

    let title = "Crawls"

    init(items: [Item]) {
        self.items = items
    }

    init(original: CrawlSection, items: [Item]) {
        self.init(items: items)
    }
}