//
//  TopMoviesTests.swift
//  MovieReviewTests
//
//  Created by Suman Chatterjee on 19/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import XCTest
import CoreData
@testable import MovieReview

class TopMoviesTests: XCTestCase,JsonLoading {
    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testMoviesRequest() {
        let  topMoviesRequest:ApiRequest  = ApiRequest(resource:MoviesResource(manageObjectContext: coreDataStack.managedContext))
        XCTAssertNotNil(topMoviesRequest, "genreRequest should not be nil")
        
    }

    
    func testTopMoviesFetch() {
        
        var jsonData = self.decode(file: "GenresLists", for: "genres")
        let  genreResources:ApiRequest  = ApiRequest(resource:GenreResource(manageObjectContext: coreDataStack.managedContext))
        let wrapper = ApiWrapper(serialization: jsonData, for:.genres)
        wrapper.items.forEach { (serialization) in
            
            let _ = genreResources.resource.makeModel(serialization: serialization)
        }
        coreDataStack.saveContext()

        jsonData = self.decode(file: "TopMovies", for: "TopMovies")
        let  moviesreResources:ApiRequest  = ApiRequest(resource:MoviesResource(manageObjectContext: coreDataStack.managedContext))
        let moviesWrapper = ApiWrapper(serialization: jsonData, for:.results)
        let _ = moviesreResources.resource.makeModel(serialization: moviesWrapper.items[0])
        coreDataStack.saveContext()

        let fetchRequest = NSFetchRequest<TopMovies>(entityName: "TopMovies")
        let movieId = 19404
        fetchRequest.predicate = NSPredicate(format: "id == %ld", movieId)
        do {
            let fetchedMovies = try coreDataStack.managedContext.fetch(fetchRequest)
            let topMovies = fetchedMovies.first
            XCTAssertTrue(topMovies?.title == "Dilwale Dulhania Le Jayenge")
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
