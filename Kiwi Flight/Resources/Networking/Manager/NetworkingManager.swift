//
//  NetworkingManager.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

protocol Networking: class {
    
}

extension URLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                completionHandler(.success((data, urlResponse)))
            }
        })
    }
}

class NetworkingManager: Networking {
    private let urlSession = URLSession.shared
    
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
        
        fetchDecodable(url: url, decoder: decoder) { (response: Result<FlightResponse, NetworkError>) in
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
    
    private func fetchDecodable<T: Decodable>(url: URL, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (data, response)):
                guard response.statusCode >= 200, response.statusCode < 300 else {
                    completion(.failure(NetworkError(response: response)))
                    return
                }
                
                do {
                    let values = try decoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch let error {
                    print(error)
                    completion(.failure(NetworkError.unsuccessError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(NetworkError(error: error)))
            }
        }.resume()
    }
}
