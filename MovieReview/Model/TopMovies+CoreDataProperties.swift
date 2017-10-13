//
//  TopMovies+CoreDataProperties.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 13/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//
//

import Foundation
import CoreData


extension TopMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopMovies> {
        return NSFetchRequest<TopMovies>(entityName: "TopMovies")
    }

    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for genres
extension TopMovies {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: Genres)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: Genres)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}
