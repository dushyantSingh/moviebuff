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
    
    static let movieB = Movie(id: 2,
                              title: "Title B",
                              posterPath: "Image B",
                              overview: "Description B")
    
    static let movieC = Movie(id: 2,
                              title: "Title C",
                              posterPath: "Image C",
                              overview: "Description C")
    
    static let movieD = Movie(id: 2,
                              title: "Title D",
                              posterPath: "Image D",
                              overview: "Description D")
    
    static let movieE = Movie(id: 2,
                              title: "Title E",
                              posterPath: "Image E",
                              overview: "Description E")
    
    static let movieF = Movie(id: 2,
                              title: "Title F",
                              posterPath: "Image F",
                              overview: "Description F")
    
    static let movieG = Movie(id: 2,
                              title: "Title G",
                              posterPath: "Image G",
                              overview: "Description G")
    
    static let movieList = MovieListModel(page: 1,
                                          totalPages: 2,
                                          totalResults: 2,
                                          movies: [MovieListModelFactory.movieA,
                                                   MovieListModelFactory.movieD])
    
    static let longMovieList = MovieListModel(page: 1,
                                              totalPages: 2,
                                              totalResults: 10,
                                              movies: [MovieListModelFactory.movieA,
                                                       MovieListModelFactory.movieB,
                                                       MovieListModelFactory.movieC,
                                                       MovieListModelFactory.movieD,
                                                       MovieListModelFactory.movieE,
                                                       MovieListModelFactory.movieG,
                                                       MovieListModelFactory.movieA,
                                                       MovieListModelFactory.movieB,
                                                       MovieListModelFactory.movieC,
                                                       MovieListModelFactory.movieD,
                                                       MovieListModelFactory.movieE,
                                                       MovieListModelFactory.movieF,
                                                       MovieListModelFactory.movieG,
                                                       MovieListModelFactory.movieA])
}
