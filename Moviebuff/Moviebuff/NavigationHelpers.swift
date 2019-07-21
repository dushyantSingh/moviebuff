//
//  NavigationHelpers.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 15/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

enum NavigationAction {
    case push(viewModel: Any, animated: Bool)
    case pop(animated: Bool)
}

extension NavigationAction: Equatable {
    static func == (lhs: NavigationAction, rhs: NavigationAction) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push):
            return true
        case (.pop, .pop):
            return true
        default: return false
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
    
    func isNearTheBottomEdge(contentOffset: CGPoint,
                             _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + StartLoadingOffset > tableView.contentSize.height
    }
}

protocol NetworkingViewModel {
    associatedtype EventType: MapToNetworkEvent
    var events: PublishSubject<EventType> { get set }
    var waitingForResponse: PublishSubject<Bool> { get set }
    var disposeBag: DisposeBag { get }
    
    func setupNetworkingEvents()
}
extension NetworkingViewModel {
    func setupNetworkingEvents() {
        self.events
            .map { $0.toNetworkEvent() }
            .filterNil()
            .map { event -> Bool in
                switch event {
                case .success(_):
                    return false
                case .failed:
                    return false
                case .waiting:
                    return true
                }
            }
            .bind(to: self.waitingForResponse)
            .disposed(by: disposeBag)
    }
}

