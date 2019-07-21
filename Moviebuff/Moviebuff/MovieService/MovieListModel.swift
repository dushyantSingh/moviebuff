//
//  MovieListModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import HandyJSON
import Foundation

struct MovieListModel: HandyJSON {
    var page: Int?
    var totalPages: Int?
    var totalResults: Int?
    var movies: [Movie]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< totalPages <-- "total_pages"
        mapper <<< totalResults <-- "total_results"
        mapper <<< movies <-- "results"
    }
}

struct Movie: HandyJSON {
    var id: Int?
    var title: String?
    var posterPath: String?
    var overview: String?
    var release_date: Date?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< posterPath <-- "poster_path"
        mapper <<< release_date <-- DateTransform()
    }
}

extension MovieListModel: Equatable {
    static func == (lhs: MovieListModel, rhs: MovieListModel) -> Bool {
        return lhs.page == rhs.page
        && lhs.totalPages == rhs.totalPages
        && lhs.totalResults == rhs.totalResults
        && lhs.movies == rhs.movies
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.posterPath == rhs.posterPath
        && lhs.overview == rhs.overview
        && lhs.release_date == rhs.release_date
    }
}
