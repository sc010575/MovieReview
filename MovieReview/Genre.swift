//
//  Genre.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 12/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation

struct Genre {
    
    let id:Int?
    let name:String?
    
}

extension Genre {
    
    private enum Keys: String,SerializationKey {
        
        case id
        case name

    }
    init (serialization:Serialization){
        id = serialization.value(forKey: Keys.id)
        name = serialization.value(forKey: Keys.name)

    }
}
