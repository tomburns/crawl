//
//  ManagedCrawl+CoreDataProperties.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagedCrawl {

    @NSManaged var body: String?
    @NSManaged var intro: String?
    @NSManaged var mediaID: String?
    @NSManaged var preTitle: String?
    @NSManaged var title: String?

}
