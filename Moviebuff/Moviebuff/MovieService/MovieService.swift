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
extension NetworkingEvent: Equatable {
    static func == (lhs: NetworkingEvent, rhs: NetworkingEvent) -> Bool {
        switch (lhs, rhs) {
        case (.waiting, .waiting):
            return true
        case (.failed, .failed):
            return true
        case (.success, .success):
            return true
        default:
            return false
        }
    }
    
    
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
                    if let responseString = String(data: response.data,
                                                   encoding: String.Encoding.utf8) {
                        guard let movieList = MovieListModel.deserialize(from: responseString) else {
                            return .failed
                        }
                        return .success(movieList)
                    } else {
                        return .failed
                    }
                } else {
                    return .failed
                }
            }.startWith(.waiting)
    }
    
    func retrievePoster(path: String) -> Observable<UIImage> {
        return self.provider.rx.request(.getPosterImage(path: path))
        .asObservable()
            .map { response in
                if response.is2xx() {
                    guard let image = try? response.mapImage() else {
                        return UIImage.defaultPosterImage()
                    }
                    return image
                }
                return UIImage.defaultPosterImage() }
        .startWith(UIImage.defaultPosterImage())
    }
}

extension Response {
    public func is2xx() -> Bool {
        if (self.statusCode >= 200) && (self.statusCode < 300) { return true }
        
        return false
    }
}
