//
//  AppSyncManager.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 12/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit
import CoreData

typealias completion = (_ state:SyncState)->()

enum SyncState {
    case offline
    case online
    case undefined
}

class AppSyncManager: NSObject,Reachability {
    
    lazy var genreRequest :ApiRequest = {
        ApiRequest(resource:GenreResource(manageObjectContext: manageObjectContext))
    }()
    lazy var movieRequest: ApiRequest = {
        ApiRequest(resource: MoviesResource(manageObjectContext: manageObjectContext))
    }()
  
    var manageObjectContext: NSManagedObjectContext!
    var coreDataStack: CoreDataStack!
    final func doDispatch(with coreDataStack:CoreDataStack, completionHandler:@escaping completion) {
        self.coreDataStack = coreDataStack
        self.manageObjectContext = self.coreDataStack.mainQueueManagedObjectContext
        
        if self.currentReachabilityStatus == .notReachable {
            
            print("No Network Connection")
            completionHandler(.offline)
            return
        }
        
        coreDataStack.deleteAllData(completion: { (isDeleteSuccess) in
            
            if isDeleteSuccess {
                loadData(completionHandler: completionHandler)
            }else{
                print("Delete Unsuccessful")
                completionHandler(.undefined)
            }
        })
}

    
    func loadData(completionHandler:@escaping completion){
        let queue = DispatchQueue.global(qos: .default) //DispatchQueue(label: "com.allaboutswift.dispatchgroup", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
    
    
        group.enter()
        queue.async (group: group) {
            self.genreRequest.load {[weak self] (genres:[Genres]?) in
                self?.coreDataStack.saveContextInBackground()
                group.leave()
    
            }
        }
    
        group.enter()
        queue.async (group: group) {
            self.movieRequest.load {[weak self] (movies: [TopMovies]?) in
                self?.coreDataStack.saveContextInBackground()
                group.leave()
    
            }
    
        }
        group.notify(queue: DispatchQueue.main) {
            completionHandler(.online)
        }
    
    }
}

