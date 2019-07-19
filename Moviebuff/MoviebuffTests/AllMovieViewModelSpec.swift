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
            beforeEach {
                disposeBag = DisposeBag()
                subject = AllMovieViewModel(movieList: MovieListModelFactory.movieList)
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
        }
    }
}
