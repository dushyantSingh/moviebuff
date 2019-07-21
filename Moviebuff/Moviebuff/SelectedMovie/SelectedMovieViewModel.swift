//
//  SelectedMovieViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 17/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import RxSwift

class SelectedMovieViewModel {
    let selectedMovie: Movie
    let movieService: MovieService
    
    let events = PublishSubject<Void>()
    let posterImage = PublishSubject<UIImage>()
   
    private let disposeBag = DisposeBag()
    
    init(selectedMovie: Movie,
         movieService: MovieService) {
        self.selectedMovie = selectedMovie
        self.movieService = movieService
        setupPosterImage()
    }
    
    func setupPosterImage() {
        self.movieService
            .retrieveLargePoster(path: selectedMovie.posterPath ?? "")
            .bind(to: self.posterImage)
        .disposed(by: disposeBag)
        
    }
}
