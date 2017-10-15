//
//  Movie.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 08/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation

public let ImageURL = "https://image.tmdb.org/t/p/w500"

struct Movie {
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: URL?
    let voteAverage: Double?
    let popularity: Double?
}

extension Movie {
    
    private enum Keys: String, SerializationKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case popularity = "popularity"
    }
    
    init(serialization: Serialization) {
        id = serialization.value(forKey: Keys.id)
        title = serialization.value(forKey: Keys.title)
        overview = serialization.value(forKey: Keys.overview)
        if let url: String = serialization.value(forKey: Keys.posterPath) {
            posterPath = URL(string: ImageURL+url)
        } else {
            posterPath = nil
        }
        if let average:Double = serialization.value(forKey:Keys.voteAverage) {
            voteAverage = average
        }else{
            voteAverage = nil
        }
        if let popular:Double = serialization.value(forKey:Keys.popularity) {
            popularity = popular
        }else{
            popularity = nil
        }
    }
}
