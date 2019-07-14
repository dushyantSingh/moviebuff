//
//  StartViewModel.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 14/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift

enum StartViewModelEvents {
    case startLoadingMovies
}
class StartViewModel {
    let events = PublishSubject<StartViewModelEvents>()
}
