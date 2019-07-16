//
//  NavigationHelpers.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 15/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit

enum NavigationAction {
    case push(viewModel: Any, animated: Bool)
    case pop(animated: Bool)
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
