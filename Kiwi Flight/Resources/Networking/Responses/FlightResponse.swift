//
//  FlightResponse.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

struct FlightResponse: Codable {
    let data: [FlightData]
    
    struct FlightData: Codable {
        let cityFrom: String
        let cityTo: String
        let price: Int
        let dTimeUTC: Date
        let aTimeUTC: Date
        let distance: Double
        let fly_duration: String
        let deep_link: URL
    }
}
