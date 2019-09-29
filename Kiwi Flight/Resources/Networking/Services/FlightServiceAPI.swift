//
//  FlightServiceAPI.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 29/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public protocol FlightService: class {
    func fetchFlights(result: @escaping (Result<[Flight], NetworkError>) -> Void)
}

final class FlightServiceImpl: FlightService {
    private var networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    public func fetchFlights(result: @escaping (Result<[Flight], NetworkError>) -> Void) {
        let dateFrom = Date()
        let dateTo = Calendar.current.date(byAdding: .day, value: 7, to: dateFrom)!
        
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        
        guard let url = try? KiwiRoute.popularFlights(dateFrom: format.string(from: dateFrom), dateTo: format.string(from: dateTo)).asURLComponents()?.url else {
            return result(.failure(NetworkError.badRequest))
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        networking.fetchDecodable(url: url, decoder: decoder) { (response: Result<FlightResponse, NetworkError>) in
            switch response {
            case .success(let values):
                let flightResult = values.data.map { (flightData) -> Flight in
                    return Flight(flightResponse: flightData)
                }
                
                result(.success(flightResult))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}
