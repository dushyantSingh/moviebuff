//
//  StartViewModelSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Moya

@testable import Moviebuff

class StartViewModelSpec: QuickSpec {
    override func spec() {
        describe("StartViewModel") {
            var subject: StartViewModel!
            var fakeProvider: FakeMoyaProvider<MovieTarget>!
            var disposeBag: DisposeBag!
            beforeEach {
                fakeProvider = FakeMoyaProvider<MovieTarget>()
                let fakeMovieService = MovieService(provider: fakeProvider)
                subject = StartViewModel(movieService: fakeMovieService)
                disposeBag = DisposeBag()
            }
            
            context("when startButtonTapped triggered") {
                var latestEvent: StartViewModelEvents!
                var waitingIndicatorCalled: Bool!
                beforeEach {
                    waitingIndicatorCalled = false
                    subject.waitingForResponse
                        .asObservable()
                        .subscribe(onNext: { waitingIndicatorCalled = $0 })
                        .disposed(by: disposeBag)
                    
                    subject.events
                        .asObservable()
                        .subscribe(onNext: { latestEvent = $0 })
                        .disposed(by: disposeBag)
                    subject.startButtonTapped.onNext(())
                }
                it("should emit waiting event") {
                    expect(waitingIndicatorCalled).to(beTrue())
                    expect(latestEvent).to(equal(.startLoadingMovies(.waiting)))
                }
                it("should emit success event") {
                    fakeProvider.responseStatusCode.onNext(200)
                    expect(waitingIndicatorCalled).to(beFalse())
                    expect(latestEvent).to(equal(.startLoadingMovies(.success("Any"))))
                }
                it("should emit failed event") {
                    fakeProvider.responseStatusCode.onNext(500)
                    expect(waitingIndicatorCalled).to(beFalse())
                    expect(latestEvent).to(equal(.startLoadingMovies(.failed)))
                }
            }
        }
    }
}
