//
//  AllMovieViewControllerSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import Moviebuff

class AllMovieViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AllMovieViewControllerSpec") {
            var subject: AllMovieViewController!
            var disposeBag: DisposeBag!
            var fakeProvider: FakeMoyaProvider<MovieTarget>!
            beforeEach {
                disposeBag = DisposeBag()
                fakeProvider = FakeMoyaProvider<MovieTarget>()
                let viewModel = AllMovieViewModel(movieList: MovieListModelFactory.movieList,
                                                  service: MovieService(provider: fakeProvider))
                subject = UIViewController.make(viewController: AllMovieViewController.self)
                subject.viewModel = viewModel
                _ = subject.view
                _ = subject.tableView.visibleCells
            }
            context("when view loads") {
                it("should show movies") {
                    expect(subject.tableView.numberOfRows(inSection: 0)).to(equal(2))
                }
                it("should show title for row") {
                    subject.tableView.scrollToRow(at: IndexPath(row: 0,section: 0),
                                                  at: .top,
                                                  animated: false)
                    let cellA = subject.tableView.cellForRow(at: IndexPath(row: 0,
                                                                          section: 0)) as? MovieTableViewCell
                    let cellD = subject.tableView.cellForRow(at: IndexPath(row: 1,
                                                                           section: 0)) as? MovieTableViewCell
                    expect(cellA?.titleLabel.text).to(equal("Title A"))
                    expect(cellA?.titleLabel.isHidden).to(beFalse())
                    expect(cellD?.titleLabel.text).to(equal("Title D"))
                    expect(cellD?.titleLabel.isHidden).to(beFalse())
                }
                it("should show image view") {
                    subject.tableView.scrollToRow(at: IndexPath(row: 0,section: 0),
                                                  at: .top,
                                                  animated: false)
                    let cellA = subject.tableView.cellForRow(at: IndexPath(row: 0,
                                                                           section: 0)) as? MovieTableViewCell
                    
                    expect(cellA?.movieImageView.image).to(equal(UIImage(named: "movie")))
                    expect(cellA?.movieImageView.isHidden).to(beFalse())
                }
            }
            
            context("when poster is retrieved") {
                context("and request is successed") {
                    beforeEach {
                        fakeProvider.responseStatusCode.onNext(200)
                    }
                    it("should display poster") {
                        subject.tableView.scrollToRow(at: IndexPath(row: 0,section: 0),
                                                      at: .top,
                                                      animated: false)
                        let cellA = subject.tableView.cellForRow(at: IndexPath(row: 0,
                                                                               section: 0)) as? MovieTableViewCell
                        expect(cellA?.movieImageView.image?.pngData()).to(equal(UIImage(named: "DummyImage")?.pngData()))
                        expect(cellA?.movieImageView.isHidden).to(beFalse())
                    }
                }
                context("and request is failed") {
                    beforeEach {
                        fakeProvider.responseStatusCode.onNext(500)
                    }
                    it("should display placeholder image") {
                        subject.tableView.scrollToRow(at: IndexPath(row: 0,section: 0),
                                                      at: .top,
                                                      animated: false)
                        let cellA = subject.tableView.cellForRow(at: IndexPath(row: 0,
                                                                               section: 0)) as? MovieTableViewCell
                        expect(cellA?.movieImageView.image?.pngData()).to(equal(UIImage(named: "movie")?.pngData()))
                        expect(cellA?.movieImageView.isHidden).to(beFalse())
                    }
                }
            }
            context("when table is scrolled to bottom") {
                var nextPageCalled = false
                beforeEach {
                    subject.skipTime = 0
                    subject.viewDidLoad()
                    subject.viewModel.movieList.accept(MovieListModelFactory.longMovieList)
                    subject.viewModel
                        .getNextPageMovie
                        .asObservable()
                        .subscribe(onNext: { nextPageCalled = true })
                    .disposed(by: disposeBag)
                   
                    
                    subject.tableView.scrollToRow(at: IndexPath(row: 13,section: 0),
                                                  at: .bottom,
                                                  animated: true)
                }
                it("should trigger getNextPageMovie") {
                   
                    expect(nextPageCalled).toEventually(beTrue(), timeout: 2)
                }
            }
            
            context("when cell is tapped") {
                it("should select the movie") {
                    var selectedMovie: Movie?
                    subject.viewModel.selectedMovie
                        .asObservable()
                        .subscribe(onNext: { selectedMovie = $0 })
                        .disposed(by: disposeBag)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    subject.tableView.delegate?.tableView!(
                        subject.tableView, didSelectRowAt: indexPath)
                    
                    expect(selectedMovie).to(equal(MovieListModelFactory.movieA))
                }
            }
            context("when waiting for response is triggered with true") {
                beforeEach {
                    subject.viewModel.waitingForResponse.onNext(true)
                }
                it("should start animating the activity indicator") {
                    expect(subject.activityIndicator.isAnimating).to(beTrue())
                }
            }
            context("when waiting for response is triggered with false") {
                beforeEach {
                    subject.viewModel.waitingForResponse.onNext(false)
                }
                it("should start animating the activity indicator") {
                    expect(subject.activityIndicator.isAnimating).to(beFalse())
                }
            }
        }
    }
}
