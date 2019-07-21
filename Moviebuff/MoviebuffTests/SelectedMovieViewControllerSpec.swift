//
//  SelectedMovieViewControllerSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 21/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import Moviebuff

class SelectedMovieViewControllerSpec: QuickSpec {
    override func spec() {
        describe("SelectedMovieViewController") {
            var subject: SelectedMovieViewController!
            var viewModel: SelectedMovieViewModel!
            var fakeProvider: FakeMoyaProvider<MovieTarget>!
            beforeEach {
                subject = UIViewController.make(viewController: SelectedMovieViewController.self)
                fakeProvider = FakeMoyaProvider<MovieTarget>()
                viewModel = SelectedMovieViewModel(selectedMovie: MovieListModelFactory.movieA,
                                                   movieService: MovieService(provider: fakeProvider))
                subject.viewModel = viewModel
                _ = subject.view
                
            }
            context("when view loads") {
                it("should show movie title") {
                    expect(subject.movieTitleLabel.text).to(equal("Title A"))
                    expect(subject.movieTitleLabel.isHidden).to(beFalse())
                }
                it("should show release date") {
                    expect(subject.releaseYearLabel.text).to(equal("Feb 01, 2020"))
                    expect(subject.releaseYearLabel.isHidden).to(beFalse())
                }
                it("should show description") {
                    expect(subject.descriptionTextView.text).to(equal("Description A"))
                    expect(subject.descriptionTextView.isHidden).to(beFalse())
                }
                it("should show poster") {
                    expect(subject.moviePosterImageView.image?.pngData()).to(equal(UIImage(named: "movie")?.pngData()))
                    expect(subject.moviePosterImageView.isHidden).to(beFalse())
                }
                
            }
        }
    }
}
