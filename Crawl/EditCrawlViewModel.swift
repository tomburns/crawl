//
//  EditCrawlViewModel.swift
//  Crawl
//
//  Created by Tom Burns on 2/6/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EditCrawlViewModelType {
    func save() -> Observable<Void>
}

class EditCrawlViewModel: EditCrawlViewModelType {

    private let crawlStore: ManagedModelStore<Crawl>

    init(dependencies: MainInterfaceDependencies) {
        self.crawlStore = dependencies.crawlStore
    }

    func save() -> Observable<Void> {
        let newCrawl = Crawl(intro: "Intro", preTitle: "Pre Title", title: NSDate().description, body: "Body")
        return crawlStore.create(newCrawl).debug("viewModel create")
    }
}