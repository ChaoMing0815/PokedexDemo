//
//  RequestType.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

enum HttpMethod: String {
  case GET = "GET"
  case POST = "POST"
}

struct RequestType {
   
  let httpMethod: HttpMethod
  let domainURL: URL
  let path: String
  let queryItems: [URLQueryItem]
  let body: Data?
   
  init(httpMethod: HttpMethod, domainURL: URL, path: String, queryItems: [URLQueryItem], body: Data? = nil) {
    self.httpMethod = httpMethod
    self.domainURL = domainURL
    self.path = path
    self.queryItems = queryItems
    self.body = body
  }
   
  func getFullURL() -> URL {
    var urlComponents = URLComponents(url: domainURL, resolvingAgainstBaseURL: false)
    urlComponents?.path += path
    if !queryItems.isEmpty {
      urlComponents?.queryItems = queryItems
    }
    guard let url = urlComponents?.url else {
      fatalError("URL should not be nil!")
    }
    return url
  }
   
  func getURLRequest() -> URLRequest {
    let fullURL = getFullURL()
    var request = URLRequest(url: fullURL)
    request.httpMethod = httpMethod.rawValue
    if let body = body {
      request.httpBody = body
    }
    return request
  }
}
