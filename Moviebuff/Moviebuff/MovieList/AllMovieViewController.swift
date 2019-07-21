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

    var skipTime = 1
    var activityIndicator = UIActivityIndicatorView()
    var activityBarButton = UIBarButtonItem()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        setupActivityIndicator()
        setupNetworkingEvent()
    }
    
    private func setupNetworkingEvent() {
        viewModel.waitingForResponse
            .asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.sizeToFit()
        activityIndicator.color = self.view.tintColor
        activityBarButton = UIBarButtonItem.init(customView: activityIndicator)
        self.navigationItem.setRightBarButton(activityBarButton, animated: true)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        self.tableView.backgroundView?.backgroundColor = UIColor(white: 230.0 / 255.0, alpha: 1.0)
        
        self.tableView.rx
            .itemSelected.asObservable()
            .map { self.viewModel.movieList.value.movies?[$0.row] }
            .filterNil()
            .bind(to: self.viewModel.selectedMovie)
            .disposed(by: disposeBag)
        
        self.tableView.rx.contentOffset
            .debounce(1, scheduler: MainScheduler.instance)
            .skip(skipTime)
            .asObservable()
            .flatMap { offset in
                self.isNearTheBottomEdge(contentOffset: offset, self.tableView)
                    ? Observable.just(()) : Observable.empty() }
            .bind(to: self.viewModel.getNextPageMovie)
            .disposed(by: disposeBag)
        
        self.viewModel.movieList
            .asObservable()
            .subscribe(onNext: { _ in self.tableView.reloadData() })
            .disposed(by: disposeBag)
    }
    
    func getIndexPath(start: Int, end: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for index in start..<end {
            indexPaths.append(IndexPath.init(row: index, section: 0))
        }
        return indexPaths
    }
}

extension AllMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.value.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell
            else {
                return UITableViewCell()
        }
        guard let movie = self.viewModel.movieList.value.movies?[indexPath.row] else {
            return cell
        }
        
        let image = viewModel.getImage(path: movie.posterPath ?? "")
        cell.configure(title: movie.title ?? "No name",
                       image: image)
        return cell
    }
}


