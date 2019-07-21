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
                                                   similarMovies: MovieListModelFactory.movieList,
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
                it("should show similar movie title") {
                    expect(subject.similarMoviesLabel.text).to(equal("Similar Movies"))
                }
                it("should show similar movies") {
                    expect(subject.collectionView.numberOfItems(inSection: 0)).to(equal(2))
                }
                it("should show image in collection cell") {
                    _ = subject.collectionView.visibleCells
                    let cell = subject.collectionView(subject.collectionView,
                                                      cellForItemAt: IndexPath(row: 0, section: 0)) as! MovieCollectionCell
                    expect(cell.movieImageView.image?.pngData()).to(equal(UIImage(named: "movie")?.pngData()))
                }
                context("when no similar movies") {
                    beforeEach {
                        var noSimilarMovies = MovieListModelFactory.movieList
                        noSimilarMovies.movies = nil
                        viewModel = SelectedMovieViewModel(selectedMovie: MovieListModelFactory.movieA,
                                                           similarMovies: noSimilarMovies,
                                                           movieService: MovieService(provider: fakeProvider))
                        subject.viewModel = viewModel
                        subject.viewDidLoad()
                        _ = subject.view
                    }
                    it("should show similar movie title") {
                        expect(subject.similarMoviesLabel.isHidden).to(beTrue())
                    }
                    it("should show similar movies") {
                        expect(subject.collectionView.numberOfItems(inSection: 0)).to(equal(0))
                    }
                }
            }
        }
    }
}
