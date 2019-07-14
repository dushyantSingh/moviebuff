//
//  MovieViewModelCoordinator.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation

class MovieViewModelCoordinator {
    
    func setupStartViewModel() -> StartViewModel {
        let viewModel = StartViewModel()
        viewModel.events
            .subscribe(onNext: { event in
                switch event {
                case .startLoadingMovies:
                    print("start loading")
                }
            })
        return viewModel
    }
}
