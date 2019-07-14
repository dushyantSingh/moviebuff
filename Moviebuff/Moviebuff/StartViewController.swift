//
//  ViewController.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ViewControllerProtocol {
    associatedtype ViewModelT
    var viewModel: ViewModelT! { get set }
}

class StartViewController: UIViewController, ViewControllerProtocol {
    
    typealias ViewModelT = StartViewModel
    var viewModel: StartViewModel!
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.rx
            .tap
            .map { StartViewModelEvents.startLoadingMovies }
        .bind(to: self.viewModel.events)
        .disposed(by: disposeBag)
    }
}

