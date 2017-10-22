//
//  LaunchViewController.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 22/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var appSync = AppSyncManager()
    var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.activityIndicator.startAnimating()
        appSync.doDispatch(with: coreDataStack) { [unowned self] in
            self.activityIndicator.stopAnimating()
            self.readyToShow()
        }
    }

    func readyToShow() {
        
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as?  MainViewController else {
            return
        }
        mainViewController.coreDataStack = self.coreDataStack
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: mainViewController)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
}
