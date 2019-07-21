//
//  DateHelpers.swift
//  Moviebuff
//
//  Created by Dushyant Singh on 21/7/19.
//  Copyright © 2019 Dushyant Singh. All rights reserved.
//

import Foundation
import HandyJSON
extension Date {
    public func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    public func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

class DateTransform: DateFormatterTransform {
    public init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        super.init(dateFormatter: formatter)
    }
}
