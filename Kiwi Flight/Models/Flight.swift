//
//  Flight.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public struct Flight {
    let from: String
    let to: String
    let price: Int
    let departureTime: Date
    let arrivalTime: Date
    let duration: String
    let linkToBook: URL
}

extension Flight {
    init(flightResponse: FlightResponse.FlightData) {
        from = flightResponse.cityFrom
        to = flightResponse.cityTo
        price = flightResponse.price
        departureTime = flightResponse.dTimeUTC
        arrivalTime = flightResponse.aTimeUTC
        duration = flightResponse.fly_duration
        linkToBook = flightResponse.deep_link
    }
}
