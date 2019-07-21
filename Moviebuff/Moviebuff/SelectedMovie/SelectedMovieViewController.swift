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
    @IBOutlet weak var moviePosterImageView: UIImageView!
   
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var similarMoviesLabel: UILabel!
    var viewModel: SelectedMovieViewModel!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupImageView()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.setContentOffset(.zero, animated: false)
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "\(MovieCollectionCell.self)", bundle: Bundle.main),
                                     forCellWithReuseIdentifier: "\(MovieCollectionCell.self)")
    }
    
    private func setupLabels() {
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 14)
        releaseYearLabel.textColor = UIColor.gray
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        similarMoviesLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        movieTitleLabel.text = viewModel.selectedMovie.title
        releaseYearLabel.text = viewModel.selectedMovie.release_date?.toString(format: "MMM dd, YYYY")
        descriptionTextView.text = viewModel.selectedMovie.overview
       
        if (viewModel.similarMovies.movies?.count ?? 0) > 0 {
            similarMoviesLabel.text = "Similar Movies"
            similarMoviesLabel.isHidden = false
        } else {
            similarMoviesLabel.isHidden = true
        }
    }
    
    private func setupImageView() {
        viewModel.posterImage
            .bind(to: self.moviePosterImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

extension SelectedMovieViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.similarMovies.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionCell.self)", for: indexPath) as? MovieCollectionCell
            else { return UICollectionViewCell() }
        
        guard let movie = viewModel.similarMovies.movies?[indexPath.row],
            let poster = movie.posterPath else {
                cell.movieImageView.image = UIImage.defaultPosterImage()
                return cell
        }
        
        viewModel.getImage(path: poster)
            .asObservable()
            .bind(to: cell.movieImageView.rx.image)
            .disposed(by: disposeBag)
        
        return cell
    }
}
