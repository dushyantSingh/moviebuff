//
//  MovieTableViewCell.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//


import Quick
import Nimble
import RxSwift
import RxCocoa

@testable import Moviebuff

class MovieTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("MovieTableViewCell") {
            var subject: MovieTableViewCell!
            beforeEach {
                let nibName = "\(MovieTableViewCell.self)"
                
                let nib = UINib(nibName: nibName,
                                bundle: Bundle(for: MovieTableViewCell.self))
                
                let nibViews = nib.instantiate(withOwner: nil, options: nil)
                
                guard let nibView = nibViews[0] as? MovieTableViewCell else {
                    fatalError("Unable to create view from nib \(nibName)")
                }
                subject = nibView
            }
            context("when configuring the cell") {
                beforeEach {
                    let placeholderImage = UIImage(named: "movie")!
                    subject.configure(title: "Some title",
                                      image: Observable.just(placeholderImage))
                }
                it("should show title") {
                    expect(subject.titleLabel.text).to(equal("Some title"))
                    expect(subject.titleLabel.isHidden).to(beFalse())
                }
                it("should show image view") {
                    expect(subject.movieImageView.isHidden).to(beFalse())
                    expect(subject.movieImageView.image).to(equal(UIImage(named: "movie")))
                }
            }
        }
    }
}
