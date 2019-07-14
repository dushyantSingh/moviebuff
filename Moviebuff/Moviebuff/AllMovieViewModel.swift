//
//  AllMovieViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation

struct Movie {
    let name: String!
}
class AllMovieViewModel {
    let movieList: [Movie]
    
    init(movieList: [Movie]) {
        self.movieList = movieList
    }
}
