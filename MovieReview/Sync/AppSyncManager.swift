//
//  AppSyncManager.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 12/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit
import CoreData

typealias completion = ()->()


class AppSyncManager: NSObject {
    
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
        self.manageObjectContext = self.coreDataStack.managedContext
        let queue = DispatchQueue.global(qos: .default) //DispatchQueue(label: "com.allaboutswift.dispatchgroup", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        group.enter()
        queue.async (group: group) {
            self.genreRequest.load {[weak self] (genres:[Genres]?) in
                self?.coreDataStack.saveContextInBackground()
                }
                group.leave()
            }
        
        group.enter()
        queue.async (group: group) {
            self.movieRequest.load {[weak self] (movies: [TopMovies]?) in
            self?.coreDataStack.saveContextInBackground()
            group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("done doing stuff again")
            completionHandler()
        }

    }
}
