//
//  MainViewModel.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 29/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation
import CoreData


struct MainViewModel {
    
    struct MainViewUIData {
        var title:String?
        var popularity:String?
        var posterPath:URL
    }
    fileprivate (set) var fetchedResultsController: NSFetchedResultsController<TopMovies>!

    var coreDataStack: CoreDataStack!
    
    lazy var numberOfRecord:Int = {
        if let sectionInfo = fetchedResultsController.sections?[0] {
            return sectionInfo.numberOfObjects
        }else{
            return 0
        }
    }()
    

    init(with stack:CoreDataStack) {
        self.coreDataStack = stack

        let fetchRequest: NSFetchRequest<TopMovies> = TopMovies.fetchRequest()
        let popularitySort  = NSSortDescriptor(key: #keyPath(TopMovies.popularity), ascending: false)
        fetchRequest.sortDescriptors = [popularitySort]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainQueueManagedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "topMovies")
    
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    func uiData(for index:IndexPath) ->MainViewUIData? {
        let topMovie = fetchedResultsController.object(at: index)
        guard let posterPath = topMovie.posterPath else { return nil}
        return  MainViewUIData(title: topMovie.title,popularity: "Popularity: \(topMovie.popularity)",posterPath: posterPath)
    }

}
