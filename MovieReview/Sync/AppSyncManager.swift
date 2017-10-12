//
//  AppSyncManager.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 12/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit

typealias completion = ()->()

class AppSyncManager: NSObject {
    let genreRequest :ApiRequest = ApiRequest(resource: GenreResource())
    let movieRequest: ApiRequest = ApiRequest(resource: MoviesResource())
    
    func doDispatch(completionHandler:@escaping completion) {
        
        let queue = DispatchQueue.global(qos: .default) //DispatchQueue(label: "com.allaboutswift.dispatchgroup", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        group.enter()
        queue.async (group: group) {
            self.genreRequest.load {[weak self] (genres:[Genre]?) in
                print(genres)
                group.leave()
            }
        }
        
        group.enter()
        queue.async (group: group) {
            self.movieRequest.load { [weak self] (movies: [Movie]?) in
                print(movies)
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("done doing stuff again")
            completionHandler()
        }

    }
}
