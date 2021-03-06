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

class StartViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.rx
            .tap
            .map { }
    }
}

