//
//  MovieTableViewCell.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var cellBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    private func setupView() {
        cellBackground.layer.cornerRadius = 3
        movieImageView.layer.cornerRadius = 3
    }
    private func setupLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.darkGray
    }
    
    func configure(title: String,
                   image: Observable<UIImage>) {
        self.titleLabel.text = title
        
        image.subscribe(onNext: {
            self.movieImageView.image = $0 })
            .disposed(by: disposeBag)
    }
}
