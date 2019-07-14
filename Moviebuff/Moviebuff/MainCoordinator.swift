//
//  MainCoordinator.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit

class MainCoordinator {
    var mainNavigationController: UINavigationController!
    let viewModelCoordinator = MovieViewModelCoordinator()
    
    init() {
        startApplication()
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
            let vc = UIViewController.make(viewController: AllMoviesViewController.self)
            vc.viewModel = viewModel
            return vc
        default:
            return UIViewController()
        }
    }
}

extension UIViewController {
    public static func make<T>(viewController: T.Type) -> T {
        let viewControllerName = String(describing: viewController)
        
        let storyboard = UIStoryboard(name: viewControllerName, bundle: Bundle(for: viewController as! AnyClass))
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Unable to create ViewController: \(viewControllerName) from storyboard: \(storyboard)")
        }
        return viewController
    }
}
