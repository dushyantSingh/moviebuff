//
//  MovieTarget.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 17/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Moya
import RxSwift

enum MovieTarget {
    case getListOfMovie(page: Int)
    case getPosterImage(path: String)
}

extension MovieTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .getListOfMovie:
            return Enviornment.manager.baseURL
        case .getPosterImage:
            return Enviornment.manager.posterURL
        }
        
    }
    
    var path: String {
        switch self {
        case .getListOfMovie:
             return "movie/popular"
        case .getPosterImage(let path):
            return "w185/\(path)"
        }
       
    }
    
    var method: Moya.Method {
        return Method.get
    }
    
    var sampleData: Data {
        switch self {
        case .getListOfMovie:
            return ResponseLoader.loadResponse(file: "MovieList")
        case .getPosterImage:
            return UIImage(named: "DummyImage")!.pngData()!
        }
    }
    
    var task: Task {
        switch self {
        case .getListOfMovie(let page):
            return .requestParameters(parameters:["api_key": Enviornment.manager.apiKey,
                                                  "page": page],
                                      encoding: URLEncoding.queryString)
        case .getPosterImage:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}


class Enviornment {
    static let manager = Enviornment()
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/")!
    }
    
    let apiKey = "48d3884bb23652fb744387b847d49137"
}
