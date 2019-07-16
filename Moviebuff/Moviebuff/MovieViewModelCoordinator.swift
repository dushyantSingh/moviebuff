//
//  MovieViewModelCoordinator.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

class MovieViewModelCoordinator {
    
    let navigationAction = PublishSubject<NavigationAction>()
    private let disposeBag = DisposeBag()
    
   
    func setupStartViewModel() -> StartViewModel {
        let viewModel = StartViewModel()
        self.setup(startViewModel: viewModel)
        .startWith(.push(viewModel: viewModel, animated: true))
        .bind(to: navigationAction)
        .disposed(by: disposeBag)
        
        return viewModel
    }
    
    func setup(startViewModel: StartViewModel) -> Observable<NavigationAction> {
        return startViewModel.events.flatMap { event  -> Observable<NavigationAction> in
            switch event {
            case .startLoadingMovies:
                let movie = Movie(name: "All Time Best")
                let viewModel = AllMovieViewModel(movieList: [movie])
                return self.setup(allMovieViewModel: viewModel)
                    .startWith(.push(viewModel: viewModel, animated: true))
            } }
    }
    
    func setup(allMovieViewModel: AllMovieViewModel) -> Observable<NavigationAction> {
        return allMovieViewModel.events
            .flatMap { event -> Observable<NavigationAction> in
                switch event {
                case .selectedMovie(let movie):
                    print("Selected Movie \(movie.name)")
                    return Observable.empty()
                }
        }
    }
}
