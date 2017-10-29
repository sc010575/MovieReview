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
    
    lazy public fileprivate(set) var mainQueueManagedObjectContext : NSManagedObjectContext = {
        let context = self.storeContainer.viewContext
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
        guard mainQueueManagedObjectContext.hasChanges else { return }
        let moc = mainQueueManagedObjectContext
        let privateMOC = privateQueueManagedObjectContext
        privateMOC.parent = mainQueueManagedObjectContext
        privateMOC.perform {
            do {
                try privateMOC.save()
                moc.performAndWait {
                    do {
                        try moc.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext () {
        guard mainQueueManagedObjectContext.hasChanges else { return }
        do {
            try mainQueueManagedObjectContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteAllData(completion:(_ deleteSuccess:Bool)->())
    {
        let entityNames = self.storeContainer.persistentStoreCoordinator.managedObjectModel.entities.map({ (entity) -> String? in
            return entity.name
        })
        entityNames.forEach { (entity) in
            if let entity = entity {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let DelAllRequest = NSBatchDeleteRequest(fetchRequest: request)
                do {
                    try mainQueueManagedObjectContext.execute(DelAllRequest)
                }
                catch {
                    print(error)
                    completion(false)
                }
            }
        }
        completion(true)
    }
}
