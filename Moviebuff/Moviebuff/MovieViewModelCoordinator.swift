//
//  MovieViewModelCoordinator.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class MovieViewModelCoordinator {
    
    let navigationAction = PublishSubject<NavigationAction>()
    private let disposeBag = DisposeBag()
    
   
    func setupStartViewModel() -> StartViewModel {
        let service = MovieService(provider: MoyaProvider<MovieTarget>())
        let viewModel = StartViewModel(movieService: service)
        
        self.setup(startViewModel: viewModel)
        .startWith(.push(viewModel: viewModel, animated: true))
        .bind(to: navigationAction)
        .disposed(by: disposeBag)
        
        return viewModel
    }
    
    func setup(startViewModel: StartViewModel) -> Observable<NavigationAction> {
        return startViewModel.events
            .flatMap { event  -> Observable<NavigationAction> in
                switch event {
                case .startLoadingMovies(.success(let movieList)):
                    guard let movieList = movieList as? MovieListModel
                        else { return Observable.empty() }
                    
                    let movieService = MovieService(provider: MoyaProvider<MovieTarget>())
                    let viewModel = AllMovieViewModel(movieList: movieList,
                                                      service: movieService)
                    
                    return self.setup(allMovieViewModel: viewModel)
                        .startWith(.push(viewModel: viewModel, animated: true))
                    
                case .startLoadingMovies(.waiting):
                   return Observable.empty()
                    
                case .startLoadingMovies(.failed):
                    return Observable.empty()
                }
        }
    }
    
    func setup(allMovieViewModel: AllMovieViewModel) -> Observable<NavigationAction> {
        return allMovieViewModel.events
            .flatMap { event -> Observable<NavigationAction> in
                switch event {
                case .selectedMovie:
                    let viewModel = SelectedMovieViewModel()
                    return self.setup(selectedViewModel: viewModel)
                        .startWith(.push(viewModel: viewModel, animated: true))
                }
        }
    }
    
    func setup(selectedViewModel: SelectedMovieViewModel) -> Observable<NavigationAction> {
        return selectedViewModel.events
            .flatMap { _ -> Observable<NavigationAction> in
                print("Something")
                return Observable.empty()
        }
    }
}
