//
//  MainCoordinatorSpec.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 16/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble

@testable import Moviebuff

class MainCoordinatorSpec: QuickSpec {

    override func spec() {
        describe("MainCoordinator") {
            var subject: MainCoordinator!
            var mockNavigationController = MockNavigationController()
            beforeEach {
                subject = MainCoordinator()
                subject.mainNavigationController = mockNavigationController
            }
            context("when navigation action emits push") {
                beforeEach {
                    let viewModel = StartViewModel()
                    subject.viewModelCoordinator
                        .navigationAction.onNext(.push(viewModel: viewModel,
                                                       animated: true))
                }
                it("should push view controller") {
                    expect(mockNavigationController.pushViewControllerCalled).to(beTrue())
                }
            }
            
            context("when navigation action emits pop") {
                beforeEach {
                    subject.viewModelCoordinator
                    .navigationAction.onNext(.pop(animated: true))
                }
                it("should dismiss view controller") {
                    expect(mockNavigationController.popViewControllerCalled).to(beTrue())
                }
            }
        }
    }
}

class MockNavigationController: UINavigationController {
    var pushViewControllerCalled = false
    var pushViewController: UIViewController? = nil
    var popViewControllerCalled = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
        pushViewController = viewController
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return nil
    }
}

