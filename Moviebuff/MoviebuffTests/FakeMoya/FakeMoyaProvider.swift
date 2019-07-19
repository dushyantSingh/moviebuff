//
//  FakeMoyaProvider.swift
//  MoviebuffTests
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Result
import Moya
import RxSwift


class FakeMoyaProvider<T: TargetType>: MoyaProvider<T> {
    
    let responseStatusCode = PublishSubject<Int>()
    let errorResponse = PublishSubject<Data>()
    let response = PublishSubject<Response>()
    private let disposeBag = DisposeBag()
    
    var sampleData: Data?
    var targetArgument: T!
    
    override func request(_ target: T,
                          callbackQueue: DispatchQueue?,
                          progress: ProgressBlock?,
                          completion: @escaping Completion) -> Cancellable {
        targetArgument = target
        
        responseStatusCode
            .map { statusCode in
                var data: Data
                if statusCode == 200 {
                    if let sampleData = self.sampleData {
                        data = sampleData
                    } else {
                        data = target.sampleData
                    }
                } else {
                    data = Data("{\"message\": \"Server error\"}".data(using: .utf8)!)
                }
                return Response(statusCode: statusCode, data: data)
            }
            .bind(to: self.response)
            .disposed(by: disposeBag)
        
        errorResponse
            .map {
                return Response(statusCode: 500, data: $0)
            }
            .bind(to: self.response)
            .disposed(by: disposeBag)
        
        response
            .subscribe(onNext: {  completion(.success($0)) })
            .disposed(by: disposeBag)
        
        return CancellableToken(action: {})
    }
}
