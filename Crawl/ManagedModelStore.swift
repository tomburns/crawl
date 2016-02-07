//
//  ManagedModelStore.swift
//  Crawl
//
//  Created by Tom Burns on 2/6/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import CoreData

import RxSwift

protocol ManagedModelStoreType {
    typealias Model: ManagedObjectConvertible
    
    var coreDataReady: Observable<Bool> { get }
    
    func create(model: Model) -> Observable<Void>
    
    func readAllStoredItems() -> Observable<[Model]>
    
    func save() -> Observable<Void>
}

class ManagedModelStore<ModelType: ManagedObjectConvertible>: ManagedModelStoreType {
    typealias Model = ModelType
    
    let managedObjectContext: NSManagedObjectContext
    
    let disposeBag = DisposeBag()
    
    internal private(set) lazy var coreDataReady: Observable<Bool> = {
        return Observable.create { observer in
            observer.onNext(false)
            
            let fileManager = NSFileManager.defaultManager()
            
            guard let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
                fatalError("No ~/Documents URL")
            }
            
            let storeURL = documentsURL.URLByAppendingPathComponent("CrawlStore.sqlite")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                guard let persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator else {
                    fatalError("No persistent store set on context.")
                }
                
                if persistentStoreCoordinator.persistentStores.count <= 0 {
                    do {
                        try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
                    } catch {
                        fatalError("Unable to configure persistent store.")
                    }
                }
                
                observer.onNext(true)
            }
            
            return NopDisposable.instance
            }
            .shareReplayLatestWhileConnected()
    }()
    
    private let contextChanges: Observable<NSNotification>
    
    lazy private(set) var allItems: Observable<[Model]> = {
        return self.contextChanges.map{ _ in () }.startWith(()).flatMapLatest { _ in return self.readAllStoredItems() }
            .shareReplayLatestWhileConnected()
            .debug("allItems")
    }()
    
    init() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("CrawlModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
                fatalError("Unable to load managed object model.")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        self.managedObjectContext = managedObjectContext
        
        self.contextChanges = NSNotificationCenter.defaultCenter().rx_notification(NSManagedObjectContextObjectsDidChangeNotification, object: managedObjectContext).debug("notification")
    }
    
    func create(model: Model) -> Observable<Void> {
        let managedObjectContext = self.managedObjectContext
        let coreDataReady = self.coreDataReady
        
        return coreDataReady.filter {$0 == true }
            .flatMap { _ -> Observable<Void> in
                return model.createManagedObjectInContext(managedObjectContext)
                    .map { _ in }
            }
            .take(1)
    }
    
    
    func readAllStoredItems() -> Observable<[Model]> {
        let managedObjectContext = self.managedObjectContext
        let coreDataReady = self.coreDataReady
        
        return Observable.deferred {
            coreDataReady.filter {$0 == true }
                .flatMapLatest { _ -> Observable<[Model]> in
                    Observable.create { observer in
                        let fetchRequest = NSFetchRequest(entityName: Model.ManagedType.entityName)
                        
                        managedObjectContext.performBlock {
                            do {
                                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                                
                                guard let typedResults = results as? [Model.ManagedType] else {
                                    throw CrawlError.CoreData(nil)
                                }
                                
                                let immutableResults = try typedResults.map { foo in
                                    try Model(managedObject: foo)
                                }
                                
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
    
    func save() -> Observable<Void> {
        
        let managedObjectContext = self.managedObjectContext
        let coreDataReady = self.coreDataReady
        
        return Observable.deferred {
            coreDataReady.filter {$0 == true }
                .flatMapLatest { _ in
                    return Observable<Void>.create { observer in
                        do {
                            try managedObjectContext.save()
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                        
                        return NopDisposable.instance
                    }
                    
            }
            
        }
    }
}