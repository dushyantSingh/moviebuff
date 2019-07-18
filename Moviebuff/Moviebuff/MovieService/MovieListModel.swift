//
//  MovieListModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import HandyJSON

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
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< posterPath <-- "poster_path"
    }
}
