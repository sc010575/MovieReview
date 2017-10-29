//
//  ViewController.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 08/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//

import UIKit
import CoreData
fileprivate let cellIdentifier = "mainTableViewCellIdentifier"

class MainViewController: UITableViewController {
    
    var viewModel:MainViewModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Top Movie Lists"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard var viewModel = self.viewModel else { return 0 }
        return  viewModel.numberOfRecord
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? MainTableViewCell else {
            return
        }
        
        let viewUIData = viewModel?.uiData(for: indexPath)
        cell.titleLabel.text = viewUIData?.title
        cell.rateLabel.text = viewUIData?.popularity
        if let posterPath = viewUIData?.posterPath {
            cell.loadImage(with: posterPath)
        }
    }
}

