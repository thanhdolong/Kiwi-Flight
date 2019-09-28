//
//  KiwiRoute.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public enum KiwiRoute {
    case popularFlights(dateFrom: String, dateTo: String)
}

extension KiwiRoute: Route {
    var baseURL: String {
        return "https://api.skypicker.com"
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularFlights:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .popularFlights:
            return "/flights"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .popularFlights(let dateFrom, let dateTo):
            return [
                "v": "3",
                "sort:": "popularity",
                "locale:": "en",
                "adults": "1",
                "children": "0",
                "infants": "0",
                "flyFrom": "49.2-16.61-250km",
                "to": "anywhere",
                "dateFrom": dateFrom,
                "dateTo": dateTo,
                "typeFlight": "oneway",
                "limit": "5",
                "one_per_date": "1",
                "one_for_city": "1",
                "partner": "picky"
            ]
        }
    }
}
