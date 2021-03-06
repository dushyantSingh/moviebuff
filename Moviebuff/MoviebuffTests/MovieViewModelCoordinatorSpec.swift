//
//  MoviebuffTests.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxSwift

@testable import Moviebuff

class MovieViewModelCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("MovieViewModelCoordinator") {
            var subject: MovieViewModelCoordinator!
            var disposeBag: DisposeBag!
            beforeEach {
                subject = MovieViewModelCoordinator()
                disposeBag = DisposeBag()
            }
            
            context("create start view model") {
                var viewModel: StartViewModel!
                beforeEach {
                    viewModel = subject.setupStartViewModel()
                }
                context("when start button is tapped") {
                    var navigationAction: NavigationAction!
                    beforeEach {
                        subject.navigationAction
                            .subscribe(onNext:{
                                navigationAction = $0  
                            })
                        .disposed(by: disposeBag)
                        viewModel.events.onNext(.startLoadingMovies(.success(MovieListModelFactory.movieList)))
                    }
                    it("should push all movie view controller") {
                        expect(navigationAction).to(equal(NavigationAction.push(viewModel: "Any", animated: true)))
                    }
                }
            }
            context("create all movie view model") {
                var viewModel: AllMovieViewModel!
                var navigationalEvents: Observable<NavigationAction>!
                beforeEach {
                    viewModel = AllMovieViewModel(movieList: MovieListModelFactory.movieList,
                                                  service: MovieService(provider: MoyaProvider<MovieTarget>()))
                    navigationalEvents = subject.setup(allMovieViewModel: viewModel)
                }
                context("when movie is selected") {
                    var navigationAction: NavigationAction!
                    beforeEach {
                        navigationalEvents
                            .subscribe(onNext:{
                                navigationAction = $0 })
                            .disposed(by: disposeBag)
                        
                        viewModel.events.onNext(.selectedMovie(movie: MovieListModelFactory.movieA))
                    }
                    it("should save selected movie") {
                        expect(subject.selectedMovie).to(equal(MovieListModelFactory.movieA))
                    }
                    it("should push selected movie view model") {
                        viewModel.events.onNext(.getReleatedMovies(.success(MovieListModelFactory.movieList)))
                        expect(navigationAction).to(equal(NavigationAction.push(viewModel: "Any", animated: true)))
                    }
                }
            }
        }
    }
}
