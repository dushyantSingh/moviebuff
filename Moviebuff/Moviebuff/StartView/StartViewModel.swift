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

enum StartViewModelEvents: MapToNetworkEvent {
    case startLoadingMovies(NetworkingEvent)
}
extension StartViewModelEvents {
    func toNetworkEvent() -> NetworkingEvent? {
        if case let .startLoadingMovies(event) = self {
            return event
        } else {
            return nil
        }
    }
}

extension StartViewModelEvents: Equatable {
    static func == (lhs: StartViewModelEvents, rhs: StartViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.startLoadingMovies(.waiting),.startLoadingMovies(.waiting)):
            return true
        case (.startLoadingMovies(.success),.startLoadingMovies(.success)):
            return true
        case (.startLoadingMovies(.failed),.startLoadingMovies(.failed)):
            return true
        default:
            return false
        }
    }
}

class StartViewModel: NetworkingViewModel {
    typealias EventType = StartViewModelEvents
    
    var title: String
    let movieService: MovieService
    
    let startButtonTapped = PublishSubject<Void>()
    var events = PublishSubject<StartViewModelEvents>()
    var waitingForResponse = PublishSubject<Bool>()
    
    var disposeBag = DisposeBag()
    init(movieService: MovieService) {
        self.title = "MovieBuff"
        self.movieService = movieService
        setupNetworkingEvents()
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
