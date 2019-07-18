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
    init(provider: MoyaProvider<MovieTarget>) {
        self.provider = provider
    }
    
    func retrieveMovieList(page: Int) -> Observable<NetworkingEvent> {
       
        self.provider.request(.getListOfMovie(page: page)) { result in
            switch result {
            case .success(let response) :
                do {
                    print( try response.mapJSON())
                } catch {
                    
                }
                return Observable.just(NetworkingEvent.failed)
            case .failure(_):
                return Observable.just(NetworkingEvent.failed)
            }
       }).startWith(NetworkingEvent.waiting)
    }
}
