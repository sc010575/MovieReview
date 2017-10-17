//
//  TestCoreDataStack.swift
//  MovieReviewTests
//
//  Created by Suman Chatterjee on 16/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation
import CoreData

@testable import MovieReview

class TestCoreDataStack: CoreDataStack {
    
    convenience init() {
        self.init(modelName: "MovieReview")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription =
            NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions =
            [persistentStoreDescription]
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(
                    "Unresolved error \(error), \(error.userInfo)")
            } }
        self.storeContainer = container
    }
}

