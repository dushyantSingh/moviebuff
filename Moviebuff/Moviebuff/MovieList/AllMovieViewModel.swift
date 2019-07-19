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

extension AllMovieViewModelEvents: Equatable {
    static func == (lhs: AllMovieViewModelEvents, rhs: AllMovieViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.selectedMovie(let A), .selectedMovie(let B)):
            return A == B
        default:
            return false
        }
    }
    
    
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
