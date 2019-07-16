//
//  MainCoordinator.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainCoordinator {
    var mainNavigationController: UINavigationController!
    let viewModelCoordinator = MovieViewModelCoordinator()
    
    private let disposeBag = DisposeBag()
    init() {
        startApplication()
        setupNavigationAction()
    }
    
    private func setupNavigationAction() {
        viewModelCoordinator.navigationAction
            .subscribe(onNext: { event in
                switch event {
                case .push(let viewModel, let animated):
                    let vc = self.getViewControllerFor(viewModel: viewModel)
                    self.mainNavigationController.pushViewController(vc, animated: animated)
                case .pop(let animated):
                    self.mainNavigationController.popViewController(animated: animated) 
                } })
            .disposed(by: disposeBag)
    }
    
    private func startApplication() {
        let viewModel = viewModelCoordinator.setupStartViewModel()
        let viewController = getViewControllerFor(viewModel: viewModel)
        self.mainNavigationController = UINavigationController(rootViewController: viewController)
    }
    
    private func getViewControllerFor(viewModel: Any) -> UIViewController {
        switch viewModel {
        case let viewModel as StartViewModel:
            let vc = UIViewController.make(viewController: StartViewController.self)
            vc.viewModel = viewModel
            return vc
        case let viewModel as AllMovieViewModel:
            let vc = UIViewController.make(viewController: AllMovieViewController.self)
            vc.viewModel = viewModel
            return vc
        default:
            return UIViewController()
        }
    }
}
