//
//  CoreDataStack.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 13/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy public fileprivate(set) var mainQueueManagedObjectContext : NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.privateQueueManagedObjectContext
        return context
    }()
    
    lazy public fileprivate(set) var privateQueueManagedObjectContext : NSManagedObjectContext =  {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.persistentStoreCoordinator = self.storeContainer.persistentStoreCoordinator
        return context
        
    }()
    
   lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContextInBackground(){
        guard managedContext.hasChanges else { return }
        let moc = managedContext
        let privateMOC = privateQueueManagedObjectContext
        privateMOC.parent = moc
        privateMOC.perform {
            do {
                try privateMOC.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
