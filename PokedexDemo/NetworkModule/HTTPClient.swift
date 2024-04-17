//
//  HTTPClient.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

class HTTPClient {
    
    let urlSession = URLSession.shared
    
    
    func request(with requestType: RequestType, completion: @escaping (Data) -> Void) {
        urlSession.dataTask(with: requestType.getURLRequest()) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let reponse = response as? HTTPURLResponse {
                print(reponse.statusCode)
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
