//
//  AllMovieViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift

enum AllMovieViewModelEvents {
    case selectedMovie(movie: Movie)
}
class AllMovieViewModel {
    let movieList: MovieListModel
    let selectedMovie = PublishSubject<Movie>()
    let events = PublishSubject<AllMovieViewModelEvents>()
    
    private let disposeBag = DisposeBag()
    
    init(movieList: MovieListModel) {
        self.movieList = movieList
        setupSelectedMovie()
    }
    
    private func setupSelectedMovie() {
        selectedMovie.asObservable()
            .map { AllMovieViewModelEvents.selectedMovie(movie: $0) }
        .bind(to: events)
        .disposed(by: disposeBag)
    }
}
