//
//  APIResources.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 08/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//https://api.themoviedb.org/3/genre/movie/list?api_key=449d682523802e0ca4f8b06d8dcf629c&language=en
//https://api.themoviedb.org/3/movie/19404?api_key=449d682523802e0ca4f8b06d8dcf629c&language=en-US
//http://api.themoviedb.org/3/movie/top_rated?api_key=449d682523802e0ca4f8b06d8dcf629c&language=en&page=2
enum ApiKeys {
    case results
    case genres
}

struct ApiWrapper {
    let items: [Serialization]
}

extension ApiWrapper {
    private enum Keys: String, SerializationKey {
        case results
        case genres
    }
    
    init(serialization: Serialization, for apiKeys:ApiKeys ) {
        switch apiKeys {
        case .results:
            items = serialization.value(forKey: Keys.results) ?? []
        case .genres:
            items = serialization.value(forKey: Keys.genres) ?? []
        }
    }
}

protocol ApiResource {
    associatedtype Model
    var manageObjectContext:NSManagedObjectContext { get }
    var methodPath: String { get }
    var apiType:ApiKeys { get }
    func makeModel(serialization: Serialization) -> Model
}

extension ApiResource {
    var url: URL {
        let baseUrl = "https://api.themoviedb.org/3"
        let apiKey = "api_key=449d682523802e0ca4f8b06d8dcf629c"
        let language = "language=en"
        let url = baseUrl + methodPath + "?" + apiKey + "&" + language
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> [Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? Serialization else {
            return nil
        }
        let wrapper = ApiWrapper(serialization: jsonSerialization, for:apiType)
        return wrapper.items.map(makeModel(serialization:))
    }
}

struct MoviesResource: ApiResource {
    typealias Model = TopMovies
    let methodPath = "/movie/top_rated"
    var manageObjectContext: NSManagedObjectContext
    let apiType: ApiKeys = .results
    func makeModel(serialization: Serialization) -> TopMovies {
        return TopMovies.newTopMovies(serialization: serialization, with: manageObjectContext)
    }
}

struct GenreResource: ApiResource {
    var manageObjectContext: NSManagedObjectContext
    typealias Model = Genres
    let methodPath = "/genre/movie/list"
    let apiType: ApiKeys = .genres
    func makeModel(serialization: Serialization) -> Genres {
        return Genres.newGenres(serialization: serialization, with: manageObjectContext )
        
    }
}
