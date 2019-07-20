//
//  AllMovieViewModel.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import Moviebuff

class AllMovieViewModelSpec: QuickSpec {
    override func spec() {
        describe("AllMovieViewModel") {
            var subject: AllMovieViewModel!
            var disposeBag: DisposeBag!
            var fakeProvider: FakeMoyaProvider<MovieTarget>!
            beforeEach {
                disposeBag = DisposeBag()
                fakeProvider = FakeMoyaProvider<MovieTarget>()
                let fakeMovieService = MovieService(provider: fakeProvider)
                subject = AllMovieViewModel(movieList: MovieListModelFactory.movieList,
                                            service: fakeMovieService)
            }
            context("when movie is selected") {
                var latestEvent: AllMovieViewModelEvents!
                beforeEach {
                    subject.events
                        .asObservable()
                        .subscribe(onNext: { latestEvent = $0 })
                        .disposed(by: disposeBag)
                    subject.selectedMovie.onNext(MovieListModelFactory.movieA)
                }
                it("should emit selected movie event") {
                    expect(latestEvent).to(equal(AllMovieViewModelEvents.selectedMovie(movie: MovieListModelFactory.movieA)))
                }
            }
            context("when page reload is called") {
                var movieListUpdateIsCalled = false
                beforeEach {
                    subject.movieList
                        .asObservable()
                        .subscribe(onNext: { _ in movieListUpdateIsCalled = true})
                        .disposed(by: disposeBag)
                }
                context("when current page is less than total pages") {
                    beforeEach {
                        movieListUpdateIsCalled = false
                        subject.getNextPageMovie.onNext(())
                    }

                    it("should trigger movie list update") {
                        fakeProvider.responseStatusCode.onNext(200)
                        expect(movieListUpdateIsCalled).to(beTrue())
                    }
                }
                context("when current page is equal to total pages") {
                    beforeEach {
                        subject.currentPage = 2
                        movieListUpdateIsCalled = false
                        subject.getNextPageMovie.onNext(())
                    }

                    it("should not trigger movie list update") {
                        fakeProvider.responseStatusCode.onNext(200)
                        expect(movieListUpdateIsCalled).to(beFalse())
                    }
                }
            }
        }
    }
}
