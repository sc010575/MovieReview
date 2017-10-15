//
//  ViewController.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 08/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    fileprivate var request1: AnyObject?
    fileprivate var request2: AnyObject?
    var coreDataStack: CoreDataStack!

    var appSync = AppSyncManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let appSync = AppSyncManager()
        appSync.doDispatch(with: coreDataStack) {
            print("done")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

