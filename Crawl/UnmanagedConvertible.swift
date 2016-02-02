//
//  UnmanagedConvertible.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import CoreData

import RxSwift

protocol ChimeManagedObject {
    static var entityName: String { get }
}

protocol UnmanagedConvertible {
    typealias UnmanagedType: ManagedObjectConvertible

    func unmanagedRepresentation() throws -> UnmanagedType
}

protocol ManagedObjectConvertible {
    typealias ManagedType: NSManagedObject, ChimeManagedObject
    func createManagedObjectInContext(context: NSManagedObjectContext) -> Observable<ManagedType>
}

extension ObservableType where E: UnmanagedConvertible {
    func mapToUnmanaged() -> Observable<E.UnmanagedType> {
        return self.map { try $0.unmanagedRepresentation() }
    }
}

extension ObservableType where E: ManagedObjectConvertible {
    func mapToManagedObjectInContext(context: NSManagedObjectContext) -> Observable<E.ManagedType> {
        return self.flatMapLatest { unmanaged -> Observable<E.ManagedType> in
            return unmanaged.createManagedObjectInContext(context)
        }
    }
}

extension ObservableType where E: SequenceType, E.Generator.Element: UnmanagedConvertible {
    func mapToUnmanaged() -> Observable<[E.Generator.Element.UnmanagedType]> {
        return self.map { sequence in try sequence.map { try $0.unmanagedRepresentation() } }
    }
}

extension ObservableType where E: SequenceType, E.Generator.Element: ManagedObjectConvertible {

    typealias ManagedType = E.Generator.Element.ManagedType

    func mapToManagedObjectsInContext(context: NSManagedObjectContext) -> Observable<[ManagedType]> {
        return self.flatMapLatest { sequence -> Observable<[ManagedType]> in

            let creationObservables = sequence.map { item in
                return item.createManagedObjectInContext(context)
            }

            return creationObservables.toObservable()
                .merge()
                .toArray()
        }
    }
}

struct FooStore {
    var done = false
}

struct Foo {
    static var store = FooStore()

    static func increment() {
        store.done = true
    }
}