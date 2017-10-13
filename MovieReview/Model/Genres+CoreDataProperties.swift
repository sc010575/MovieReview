//
//  Genres+CoreDataProperties.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 13/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//
//

import Foundation
import CoreData


extension Genres {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genres> {
        return NSFetchRequest<Genres>(entityName: "Genres")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var topMovies: TopMovies?

}
