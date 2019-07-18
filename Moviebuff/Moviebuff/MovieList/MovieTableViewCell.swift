//
//  MovieTableViewCell.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var cellBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
        setupView()
    }
    
    private func setupView() {
        cellBackground.layer.cornerRadius = 3
    }
    private func setupLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.darkGray
    }
    
    func configure(title: String,
                   image: UIImage?) {
        self.titleLabel.text = title
        
        if let image = image {
            self.movieImageView?.image = image
            self.movieImageView.isHidden = false
        } else {
            self.movieImageView.isHidden = true
            self.movieImageView.image = nil
        }
        
    }
}
