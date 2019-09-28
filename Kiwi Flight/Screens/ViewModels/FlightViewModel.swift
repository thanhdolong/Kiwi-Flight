//
//  FlightViewModel.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public class FlightViewModel {
    private let flights: [Flight]
    
    init(flights: [Flight]) {
        self.flights = flights
    }
    
    public var numberOfRowsInSection: Int {
        return flights.count
    }
    
    public func configureFlightCell(_ view: FlightCell, for indexPath: IndexPath) {
        let flight = flights[indexPath.row]
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        let headerFormat = DateFormatter()
        headerFormat.dateFormat = "E, d MMM yyyy"
        
        view.departureTimeLabel.text = headerFormat.string(from: flight.departureTime)
        view.fromLabel.text = "\(format.string(from: flight.departureTime)) \(flight.from)"
        view.toLabel.text = "\(format.string(from: flight.arrivalTime)) \(flight.to)"
        view.durationLabel.text = "Travel time: \(flight.duration)"
        view.priceLabel.text = "\(flight.price) €"
    }
}
