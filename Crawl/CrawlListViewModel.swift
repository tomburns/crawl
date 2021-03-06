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

protocol CrawlListViewModelType {
    var sections: Driver<[CrawlSection]> { get }
}

struct CrawlListViewModel: CrawlListViewModelType {
    
    let sections: Driver<[CrawlSection]>
    
    private let crawlStore: ManagedModelStore<Crawl>
    
    init(crawlStore: ManagedModelStore<Crawl>) {
        self.crawlStore = crawlStore
        
        self.sections = crawlStore.allItems
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