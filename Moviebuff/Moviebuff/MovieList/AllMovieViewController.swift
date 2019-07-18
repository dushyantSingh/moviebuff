//
//  AllMoviesViewController.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import UIKit

class AllMovieViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelT = AllMovieViewModel
    var viewModel: AllMovieViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "MoiveCell")
        
        self.tableView.rx
            .itemSelected.asObservable()
            .map { self.viewModel.movieList.movies?[$0.row] }
            .filterNil()
            .bind(to: self.viewModel.selectedMovie)
            .disposed(by: disposeBag)
    }
}

extension AllMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoiveCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.viewModel.movieList.movies?[indexPath.row].title
        return cell
    }
}
