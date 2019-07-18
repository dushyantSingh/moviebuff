//
//  MovieService.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 18/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Moya
import RxSwift

enum NetworkingEvent {
    case waiting
    case success(Any)
    case failed
}
protocol MovieServiceType {
    func retrieveMovieList(page: Int) -> Observable<NetworkingEvent>
}

class MovieService: MovieServiceType {
    let provider: MoyaProvider<MovieTarget>
    
    private let disposeBag = DisposeBag()

    init(provider: MoyaProvider<MovieTarget>) {
        self.provider = provider
    }
    
    func retrieveMovieList(page: Int) -> Observable<NetworkingEvent> {
       return self.provider.rx
            .request(.getListOfMovie(page: page))
            .asObservable()
            .map { response in
                if response.is2xx() {
                    if let responseString = String(data: response.data, encoding: String.Encoding.utf8) {
                        return .success(responseString)
                    } else {
                        return .failed
                    }
                } else {
                    return .failed
                }
        }.startWith(.waiting)
            
    }
}

extension Response {
    public func is2xx() -> Bool {
        if (self.statusCode >= 200) && (self.statusCode < 300) { return true }
        
        return false
    }
}
