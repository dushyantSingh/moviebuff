//
//  DataFactory.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
@testable import Moviebuff

struct MovieListModelFactory {
    static let movieA = Movie(id: 1,
                              title: "Title A",
                              posterPath: "Image A",
                              overview: "Description A")
    
    static let movieD = Movie(id: 2,
                              title: "Title D",
                              posterPath: "Image D",
                              overview: "Description D")
    
    static let movieList = MovieListModel(page: 1,
                                          totalPages: 2,
                                          totalResults: 2,
                                          movies: [MovieListModelFactory.movieA,
                                                   MovieListModelFactory.movieD])
}
