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
import Moya

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
        self.title = viewModel.title
        setupStart()
    }
    
    private func setupStart() {
        startButton.rx.tap
            .bind(to: viewModel.startButtonTapped)
            .disposed(by: disposeBag)
    }
}

