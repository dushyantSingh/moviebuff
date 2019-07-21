//
//  StartViewControllerSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 18/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//


import Quick
import Nimble
import RxSwift
import Moya

@testable import Moviebuff

class StartViewControllerSpec : QuickSpec {
    override func spec() {
        describe("StartViewController") {
            var subject: StartViewController!
            var viewModel: StartViewModel!
            var disposeBag: DisposeBag!
            beforeEach {
                subject = UIViewController.make(viewController: StartViewController.self)
                let service = MovieService(provider: MoyaProvider<MovieTarget>())
                viewModel = StartViewModel(movieService: service)
                disposeBag = DisposeBag()
                subject.viewModel = viewModel
                _ = subject.view
            }
            context("when the View loads") {
                it("should have the title") {
                    expect(subject.title).to(equal("MovieBuff"))
                }
                it("should have a start button") {
                    expect(subject.startButton.isHidden).to(beFalse())
                    expect(subject.startButton.isEnabled).to(beTrue())
                    expect(subject.activityIndicator.isAnimating).to(beFalse())
                    expect(subject.startButton.titleLabel?.text).to(equal("Start"))
                }
            }
            context("when start button is tapped") {
                it("should trigger event") {
                    var startButtonClicked = false
                    viewModel.startButtonTapped
                        .asObservable()
                        .subscribe(onNext: { startButtonClicked = true })
                        .disposed(by: disposeBag)
                    subject.startButton.sendActions(for: .touchUpInside)
                    expect(startButtonClicked).to(beTrue())
                }
            }
            context("when waiting for response is triggered with true") {
                beforeEach {
                    subject.viewModel.waitingForResponse.onNext(true)
                }
                it("should disable start button") {
                    expect(subject.startButton.isEnabled).to(beFalse())
                }
                it("should start animating the activity indicator") {
                    expect(subject.activityIndicator.isAnimating).to(beTrue())
                }
            }
            context("when waiting for response is triggered with false") {
                beforeEach {
                    subject.viewModel.waitingForResponse.onNext(false)
                }
                it("should disable start button") {
                    expect(subject.startButton.isEnabled).to(beTrue())
                }
                it("should start animating the activity indicator") {
                    expect(subject.activityIndicator.isAnimating).to(beFalse())
                }
            }
        }
    }
}
