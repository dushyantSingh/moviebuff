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
    
    let navigationAction = PublishSubject<Any>()
    private let disposeBag = DisposeBag()
    
    func setupStartViewModel() -> StartViewModel {
        let viewModel = StartViewModel()
        viewModel.events
            .map { event in
                switch event {
                case .startLoadingMovies:
                    let movie = Movie(name: "All Time Best")
                    return AllMovieViewModel(movieList: [movie])
                } }
            .bind(to: self.navigationAction)
            .disposed(by: disposeBag)
        return viewModel
    }
}
