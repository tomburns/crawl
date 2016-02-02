//
//  ManagedCrawl.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedCrawl)
class ManagedCrawl: NSManagedObject, UnmanagedConvertible, ChimeManagedObject {
    typealias UnmanagedType = Crawl

    static let entityName = "Crawl"

    func unmanagedRepresentation() throws -> UnmanagedType  {
        guard let intro = intro,
            let preTitle = preTitle,
            let title = title,
            let body = body else {
                throw CrawlError.CoreData
        }
        return Crawl(intro: intro, preTitle: preTitle, title: title, body: body, mediaID: mediaID)
    }
}
