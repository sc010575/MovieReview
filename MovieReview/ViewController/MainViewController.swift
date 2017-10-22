//
//  ViewController.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 08/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit
import CoreData
fileprivate let cellIdentifier = "mainTableViewCellIdentifier"

class MainViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<TopMovies>!
    var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Top Movie Lists"
        
        let fetchRequest: NSFetchRequest<TopMovies> = TopMovies.fetchRequest()
        let popularitySort  = NSSortDescriptor(key: #keyPath(TopMovies.popularity), ascending: false)
        fetchRequest.sortDescriptors = [popularitySort]
        
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "topMovies")
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo =
            fetchedResultsController.sections?[0] else {
                return 0 }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? MainTableViewCell else {
            return
        }
        
        let topMovie = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = topMovie.title
        cell.rateLabel.text = "Popularity: \(topMovie.popularity)"
        
        guard let posterPath = topMovie.posterPath else { return }
        cell.loadImage(with: posterPath)
    }
}

