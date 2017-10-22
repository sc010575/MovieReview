//
//  MainTableViewCell.swift
//  MovieReview
//
//  Created by Suman Chatterjee on 22/10/2017.
//  Copyright © 2017 Suman Chatterjee. All rights reserved.
//
import Foundation
import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate var request: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadImage(with posterPath:URL){
        let avatarRequest = ImageRequest(url: posterPath)
        self.request = avatarRequest
        self.activityIndicator.startAnimating()
        avatarRequest.load(withCompletion: { [weak self] (avatar: UIImage?) in
            guard let avatar = avatar else {
                return
            }
            self?.activityIndicator.stopAnimating()
            self?.iconImageView.image = avatar
        })
    }
}
