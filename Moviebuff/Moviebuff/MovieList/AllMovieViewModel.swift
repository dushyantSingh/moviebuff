//
//  AllMovieViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Moya

enum AllMovieViewModelEvents {
    case selectedMovie(movie: Movie)
}

extension AllMovieViewModelEvents: Equatable {
    static func == (lhs: AllMovieViewModelEvents, rhs: AllMovieViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.selectedMovie(let A), .selectedMovie(let B)):
            return A == B
        }
    }
}

class AllMovieViewModel {
    
    var movieList: BehaviorRelay<MovieListModel>
    var movieService: MovieService
    
    let selectedMovie = PublishSubject<Movie>()
    let getNextPageMovie = PublishSubject<Void>()
    let events = PublishSubject<AllMovieViewModelEvents>()
    
    private let disposeBag = DisposeBag()
    var currentPage = 1
    private var maxPages = 0
    
    init(movieList: MovieListModel,
         service: MovieService) {
        self.movieList = BehaviorRelay(value: movieList)
        self.maxPages = movieList.totalPages ?? 0
        self.movieService = service
        setupSelectedMovie()
        setupNextPageMovie()
    }
    
    private func setupSelectedMovie() {
        selectedMovie.asObservable()
            .map { AllMovieViewModelEvents.selectedMovie(movie: $0) }
        .bind(to: events)
        .disposed(by: disposeBag)
    }
    
    private func setupNextPageMovie() {
        getNextPageMovie.asObservable()
            .filter { self.currentPage < self.maxPages }
            .flatMap { self.movieService.retrieveMovieList(page: self.currentPage + 1 )}
            .subscribe(onNext: { event in
                switch event {
                case .success(let nextMovieList):
                    guard let movies = (nextMovieList as? MovieListModel)?.movies else { break }
                    self.currentPage += 1
                    var movieList = self.movieList.value
                    movieList.movies?.append(contentsOf: movies)
                    self.movieList.accept(movieList)
                default: break
                } })
            .disposed(by: disposeBag)
    }
    
    func getImage(path: String) -> Observable<UIImage> {
        return self.movieService.retrievePoster(path: path)
    }
}
