//
//  CrawlStore.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import RxSwift
import CoreData

class CrawlStore {
    let managedObjectContext: NSManagedObjectContext
    
    internal private(set) lazy var coreDataReady: Observable<Bool> = {
        return Observable.create { observer in
            observer.onNext(false)
            
            let fileManager = NSFileManager.defaultManager()
            
            guard let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
                fatalError("No ~/Documents URL")
            }
            
            let storeURL = documentsURL.URLByAppendingPathComponent("CrawlStore.sqlite")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                guard let persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator,
                    let _ = try? persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil) else {
                        fatalError("Unable to configure persistent store.")
                }
                
                observer.onNext(true)
            }
            
            return NopDisposable.instance
            }
            .debug()
            .shareReplay(1)
    }()
    
    private let disposeBag = DisposeBag()
    
    init() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("CrawlModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
                fatalError("Unable to load managed object model.")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        self.managedObjectContext = managedObjectContext
        
        
        
        coreDataReady.filter {$0 == true }
            .flatMapLatest { _ -> Observable<[Crawl]> in
                
                let moc = self.managedObjectContext
                moc.performBlockAndWait {
                    let newCrawl = NSEntityDescription.insertNewObjectForEntityForName(ManagedCrawl.entityName, inManagedObjectContext: moc) as! ManagedCrawl
                    
                    newCrawl.title = "Foo"
                    newCrawl.preTitle = "Foo"
                    newCrawl.intro = "Bar"
                    newCrawl.body = "Baz"
                    
                    guard let _ = try? moc.save() else {
                        print("save failed")
                        return
                    }
                    
                }
                
                return self.allCrawls()
            }
            .subscribe({ (event) -> Void in
                print(event)
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func allCrawls() -> Observable<[Crawl]> {
        let managedObjectContext = self.managedObjectContext
        
        return Observable.deferred {
            Observable.create { observer in
                let fetchRequest = NSFetchRequest(entityName: ManagedCrawl.entityName)
                
                managedObjectContext.performBlock {
                    guard let results = try? managedObjectContext.executeFetchRequest(fetchRequest),
                        let typedResults = results as? [ManagedCrawl] else {
                            observer.onError(CrawlError.CoreData)
                            return
                    }
    
                    do {
                        let immutableResults = try typedResults.map(Crawl.init)
                        observer.onNext(immutableResults)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return NopDisposable.instance
            }
        }
    }
}
