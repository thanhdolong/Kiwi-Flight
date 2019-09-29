//
//  NetworkingManager.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public protocol Networking: class {
    func fetchDecodable<T: Decodable>(url: URL, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void) 
}

class NetworkingManager: Networking {
    private let urlSession = URLSession.shared
    
    internal func fetchDecodable<T: Decodable>(url: URL, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, NetworkError>) -> Void) {
        
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
