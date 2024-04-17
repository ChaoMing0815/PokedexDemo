//
//  HTTPClient.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

enum HTTPClientError: Error {
    case NetworkError
    case ResponseAndDataNilError
}

class HTTPClient {
    let urlSession = URLSession.shared
    
    func request(with requestType: RequestType, completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void) {
        urlSession.dataTask(with: requestType.getURLRequest()) { data, response, error in
            if let _ = error {
                completion(Result.failure(.NetworkError))
                return
            }
            guard
                let reponse = response as? HTTPURLResponse,
                let data = data
            else {
                completion(Result.failure(.ResponseAndDataNilError))
                return
            }
            completion(Result.success((data, reponse)))
        }.resume()
    }
}
