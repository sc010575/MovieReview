//
//  JsonLoading.swift
//  MovieReviewTests
//
//  Created by Suman Chatterjee on 16/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit
@testable import MovieReview

protocol JsonLoading: class {
    func decode(file fileName:String, for key:String) -> Serialization
}

extension JsonLoading {
    
    func decode(file fileName:String, for key:String) -> Serialization {
        
        var jsonDict : [String : AnyObject]!
        let loadJSONFile : (_ fileName : String) -> AnyObject =  { filename in
            let bundle = Bundle(for:type(of: self))
            let path = bundle.path(forResource: filename, ofType: "json")
            let data = NSData(contentsOfFile:path!)
            return try! JSONSerialization.jsonObject(with: data! as Data,options:JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
        }
        jsonDict =  loadJSONFile(fileName) as? [String : AnyObject]
        
        let jsonData = jsonDict ?? [:]
        return jsonData
        
    }

}
