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

extension Genres  {
    
    private enum Keys: String,SerializationKey {
        
        case id
        case name
        
    }
    
    class func newGenres(serialization:Serialization, with managedContext:NSManagedObjectContext?) -> Genres {
        let genresEntity = NSEntityDescription.entity(forEntityName: String(describing: Genres.self), in:managedContext!)
        let genre = Genres(entity: genresEntity!, insertInto: managedContext)
        genre.id = Int16(serialization.value(forKey: Keys.id) ?? 0)
        genre.name = serialization.value(forKey: Keys.name)
        return genre
    }
}
