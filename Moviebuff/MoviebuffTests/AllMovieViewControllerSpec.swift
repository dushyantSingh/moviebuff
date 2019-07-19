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
            beforeEach {
                let viewModel = AllMovieViewModel(movieList: MovieListModelFactory.movieList)
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
            }
        }
    }
}
