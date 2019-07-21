//
//  SelectedMovieViewModelSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 21/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import Moviebuff

class SelectedMovieViewModelSpec: QuickSpec {
    override func spec() {
        describe("SelectedMovieViewModel") {
            var subject: SelectedMovieViewModel!
            var fakeProvider: FakeMoyaProvider<MovieTarget>!
            var movie: Movie!
            var disposeBag: DisposeBag!
            beforeEach {
                fakeProvider = FakeMoyaProvider<MovieTarget>()
                disposeBag = DisposeBag()
                
                subject = SelectedMovieViewModel(selectedMovie: MovieListModelFactory.movieA,
                                                 movieService: MovieService(provider: fakeProvider))
            }
            context("when view setups") {
                context("when retrieves large poster image") {
                    var actualImage: UIImage!
                    beforeEach {
                        subject.posterImage
                            .asObservable()
                            .subscribe(onNext:{ actualImage = $0})
                        .disposed(by: disposeBag)
                        subject.setupPosterImage()
                        
                    }
                    it("returns a placeholder image") {
                        expect(actualImage.pngData()).to(equal(UIImage(named: "movie")?.pngData()))
                    }
                    it("returns large poster image") {
                        fakeProvider.responseStatusCode.onNext(200)
                        expect(actualImage.pngData()).to(equal(UIImage(named: "DummyImage")?.pngData()))
                    }
                }
            }
        }
    }
}
