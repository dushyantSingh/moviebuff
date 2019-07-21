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

enum AllMovieViewModelEvents: MapToNetworkEvent {
    case selectedMovie(movie: Movie)
    case getReleatedMovies(NetworkingEvent)
}

extension AllMovieViewModelEvents {
    func toNetworkEvent() -> NetworkingEvent? {
        if case let .getReleatedMovies(event) = self {
            return event
        } else {
            return nil
        }
    }
}

extension AllMovieViewModelEvents: Equatable {
    static func == (lhs: AllMovieViewModelEvents, rhs: AllMovieViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.selectedMovie(let A), .selectedMovie(let B)):
            return A == B
        case (.getReleatedMovies(let A), .getReleatedMovies(let B)):
            return A == B
        default: return false
        }
    }
}

protocol MapToNetworkEvent {
    func toNetworkEvent() -> NetworkingEvent?
}

class AllMovieViewModel: NetworkingViewModel {
    typealias EventType = AllMovieViewModelEvents
    
    var movieList: BehaviorRelay<MovieListModel>
    var movieService: MovieService
    
    var currentPage = 1
    private var maxPages = 0
    
    let selectedMovie = PublishSubject<Movie>()
    let getNextPageMovie = PublishSubject<Void>()
    var events = PublishSubject<AllMovieViewModelEvents>()
    var waitingForResponse = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    init(movieList: MovieListModel,
         service: MovieService) {
        self.movieList = BehaviorRelay(value: movieList)
        self.maxPages = movieList.totalPages ?? 0
        self.movieService = service
        setupSelectedMovie()
        setupNextPageMovie()
        setupNetworkingEvents()
    }
    
    private func setupSelectedMovie() {
        selectedMovie.asObservable()
            .map { AllMovieViewModelEvents.selectedMovie(movie: $0) }
            .bind(to: events)
            .disposed(by: disposeBag)
        
        selectedMovie.asObservable()
            .filter { $0.id != nil }
            .flatMap { movie in
                self.movieService.retrieveSimilarMovieList(movieID: movie.id!) }
            .map { AllMovieViewModelEvents.getReleatedMovies($0) }
            .bind(to: self.events)
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
