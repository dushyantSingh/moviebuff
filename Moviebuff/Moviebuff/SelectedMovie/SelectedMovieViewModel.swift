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
    let similarMovies: MovieListModel
    let movieService: MovieService
    
    let events = PublishSubject<Void>()
    let posterImage = PublishSubject<UIImage>()
   
    private let disposeBag = DisposeBag()
    
    init(selectedMovie: Movie,
         similarMovies: MovieListModel,
         movieService: MovieService) {
        self.selectedMovie = selectedMovie
        self.similarMovies = similarMovies
        self.movieService = movieService
        setupPosterImage()
    }
    
    func setupPosterImage() {
        self.movieService
            .retrieveLargePoster(path: selectedMovie.posterPath ?? "")
            .bind(to: self.posterImage)
        .disposed(by: disposeBag)
        
    }
    
    func getImage(path: String) -> Observable<UIImage> {
        return self.movieService.retrievePoster(path: path)
    }
}
