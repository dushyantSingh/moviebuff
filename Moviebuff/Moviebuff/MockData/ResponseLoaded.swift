
//
//  ResponseLoaded.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 19/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation

class ResponseLoader {
    static func loadResponse(file: String,
                             bundle: Bundle = Bundle.main) -> Data {
        guard let url = bundle.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}
