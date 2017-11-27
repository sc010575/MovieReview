//
//  GenresModelTests.swift
//  MovieReviewTests
//
//  Created by Suman Chatterjee on 16/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import XCTest
import CoreData
@testable import MovieReview

class GenresModelTests: XCTestCase,JsonLoading {
    var coreDataStack: CoreDataStack!
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testgenreRequest() {
        let  genreRequest:ApiRequest  = ApiRequest(resource:GenreResource(manageObjectContext: coreDataStack.mainQueueManagedObjectContext))
        XCTAssertNotNil(genreRequest, "genreRequest should not be nil")
        
    }
    
    func testNewGenres() {
        
        let jsonData = self.decode(file: "GenresLists", for: "genres")
        let  genreResources:ApiRequest  = ApiRequest(resource:GenreResource(manageObjectContext: coreDataStack.mainQueueManagedObjectContext))
        let wrapper = ApiWrapper(serialization: jsonData, for:.genres)
        let _ = genreResources.resource.makeModel(serialization: wrapper.items[0])
        coreDataStack.saveContext()
        
        let fetchRequest = NSFetchRequest<Genres>(entityName: "Genres")
        let count = try! coreDataStack.mainQueueManagedObjectContext.count(for: fetchRequest)
        XCTAssertTrue(count == 1)
        
    }
    
    func testGenresFetchRequests() {
        
        let jsonData = self.decode(file: "GenresLists", for: "genres")
        let  genreResources:ApiRequest  = ApiRequest(resource:GenreResource(manageObjectContext: coreDataStack.mainQueueManagedObjectContext))
        let wrapper = ApiWrapper(serialization: jsonData, for:.genres)
        wrapper.items.forEach { (item) in
            let _ = genreResources.resource.makeModel(serialization: item)
        }
        coreDataStack.saveContext()
        
        let fetchRequest = NSFetchRequest<Genres>(entityName: "Genres")
        let filter = 10770
        fetchRequest.predicate = NSPredicate(format: "id == %ld", filter)
        do {
            let fetchedGenre = try coreDataStack.mainQueueManagedObjectContext.fetch(fetchRequest)
            let genries = fetchedGenre.first
            let name = genries?.name ?? ""
            XCTAssertTrue(name == "TV Movie")
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }

}
