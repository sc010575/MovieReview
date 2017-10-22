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

public let ImageURL = "https://image.tmdb.org/t/p/w500"

extension TopMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopMovies> {
        return NSFetchRequest<TopMovies>(entityName: "TopMovies")
    }

    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: URL?
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

extension TopMovies {
    
    private enum Keys: String, SerializationKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case genresId = "genre_ids"
    }
    
    class func newTopMovies(serialization:Serialization, with managedContext:NSManagedObjectContext?) -> TopMovies {
        
        let topMovieEntity = NSEntityDescription.entity(forEntityName: String(describing: TopMovies.self), in:managedContext!)
        let topMovies = TopMovies(entity: topMovieEntity!, insertInto: managedContext)

        topMovies.id = Int32(serialization.value(forKey: Keys.id) ?? 0)
        topMovies.title = serialization.value(forKey: Keys.title)
        topMovies.overview = serialization.value(forKey: Keys.overview)
        if let url: String = serialization.value(forKey: Keys.posterPath) {
            topMovies.posterPath = URL(string: ImageURL+url)
        } else {
            topMovies.posterPath = nil
        }
        if let average:Double = serialization.value(forKey:Keys.voteAverage) {
            topMovies.voteAverage = average
        }else{
            topMovies.voteAverage = 0
        }
        if let popular:Double = serialization.value(forKey:Keys.popularity) {
            topMovies.popularity = popular
        }else{
            topMovies.popularity = 0
        }
        let genresIds:[Int16] = serialization.value(forKey:Keys.genresId) ?? []
        
        // Populate genres Lists
        var genresLists:[Genres] = []
        let fetchRequest = NSFetchRequest<Genres>(entityName: "Genres")
        do {
            let fetchedGenre = try managedContext?.fetch(fetchRequest)
            genresIds.forEach({ (id) in
                guard let genres = fetchedGenre?.filter( { $0.id == id}),let genre:Genres = genres.first else {
                    return
                }
                genresLists.append(genre)
            })
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        topMovies.genres =  NSSet(array: genresLists)
        return topMovies
    }
}

