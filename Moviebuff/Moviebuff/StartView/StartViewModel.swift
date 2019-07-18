//
//  StartViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum StartViewModelEvents {
    case startLoadingMovies(NetworkingEvent)
}
class StartViewModel {
    var title: String
    let movieService: MovieService
    
    let startButtonTapped = PublishSubject<Void>()
    let events = PublishSubject<StartViewModelEvents>()
    
    private let disposeBag = DisposeBag()
    init(movieService: MovieService) {
        self.title = "Application Start"
        self.movieService = movieService
        
        setupStart()
    }
    
    private func setupStart() {
        startButtonTapped.asObservable()
            .flatMap { self.movieService.retrieveMovieList(page: 1)}
            .map { StartViewModelEvents.startLoadingMovies($0) }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }
}
