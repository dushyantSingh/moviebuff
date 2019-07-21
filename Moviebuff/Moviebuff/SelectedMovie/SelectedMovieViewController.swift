//
//  SelectedMovieViewController.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 17/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

class SelectedMovieViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelT = SelectedMovieViewModel
   
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
   
    @IBOutlet weak var descriptionTextView: UITextView!
    var viewModel: SelectedMovieViewModel!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.setContentOffset(.zero, animated: false)
    }
    private func setupLabels() {
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 14)
        releaseYearLabel.textColor = UIColor.gray
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        
        movieTitleLabel.text = viewModel.selectedMovie.title
        releaseYearLabel.text = viewModel.selectedMovie.release_date?.toString(format: "MMM dd, YYYY")
        descriptionTextView.text = viewModel.selectedMovie.overview
    }
    
    private func setupImageView() {
        viewModel.posterImage
            .bind(to: self.moviePosterImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
