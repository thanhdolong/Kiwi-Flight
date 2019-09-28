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
    
    public func fetchFlights(result: @escaping (Result<FlightResponse, NetworkError>) -> Void) {
        
        guard let url = try? KiwiRoute.popularFlights.asURLComponents()?.url else {
            return result(.failure(NetworkError.badRequest))
        }
        
        fetchDecodable(url: url, completion: result)
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
