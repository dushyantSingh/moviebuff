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
}

extension MovieTarget: TargetType {
    var baseURL: URL {
        return Enviornment.manager.baseURL
    }
    
    var path: String {
        return "movie/popular"
    }
    
    var method: Moya.Method {
        return Method.get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getListOfMovie(let page):
            return .requestParameters(parameters:["api_key": Enviornment.manager.apiKey,
                                                  "page": page],
                                      encoding: URLEncoding.queryString)
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
    
    let apiKey = "48d3884bb23652fb744387b847d49137"
}
