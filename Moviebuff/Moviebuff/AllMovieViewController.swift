//
//  AllMoviesViewController.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import UIKit

class AllMovieViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelT = AllMovieViewModel
    var viewModel: AllMovieViewModel!
    
}

extension AllMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoiveCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.viewModel.movieList[indexPath.row].name
        return cell
    }
}
