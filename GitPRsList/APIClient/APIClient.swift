//
//  APIClient.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 27/09/22.
//

import Foundation

final class APIClient: APIClientInterface {
  
  // MARK: - Private properties
  
  private let urlSession: URLSession
  private let baseURL: String
  
  // MARK: - Public properties
  
  public static let shared: APIClientInterface =  APIClient()
  
  // MARK: - Init
  
  private init() {
    self.urlSession = URLSession(configuration: .default)
    self.baseURL = EnvironmentVariablesImpl.shared.baseURL
  }
  
  // MARK: - Private methods
  
  /// Setup URLRequest Header
  /// - Parameter request: Passing reference for parameter
  private func setHeaders(request: inout URLRequest) {
    request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  }
  
  
  /// Add Query Items to URL
  /// - Parameters:
  ///   - baseURL: Base URL with API Endpoint
  ///   - queryItems: Query Items to append
  /// - Returns: URL
  private func createURL(baseURL: String, queryItems: [(name: String, value: String)]) -> URL? {
    var urlComponent = URLComponents(string: baseURL)
    
    var queryItemsArray: [URLQueryItem] = []
    queryItems.forEach({ filter in
      queryItemsArray.append(URLQueryItem(name: filter.name, value: filter.value))
    })
    
    urlComponent?.queryItems = queryItemsArray
    
    return urlComponent?.url
  }
  
  // MARK: - APIClientInterface methods
  
  /// Get Public Repo's list of Pull Requests
  /// - Parameters:
  ///   - username: github username
  ///   - repo: github respository name
  ///   - completion: URLSession response
  func getPullRequests(username: String,
                       repo: String,
                       filters: [(name: String, value: String)],
                       completion: @escaping (Result<Data, Error>) -> Void) {
    
    guard let baseURL = createURL(baseURL: String(format: "%@/repos/%@/%@/pulls", self.baseURL, username, repo),
                                  queryItems: filters) else {
      return completion(.failure(APIClientError.invalidURL))
    }
    
    var urlRequest = URLRequest(url: baseURL)
    
    urlRequest.httpMethod = HTTPMethod.get.rawValue
    setHeaders(request: &urlRequest)
    
    let task = self.urlSession.dataTask(with: urlRequest) { (data, response, error) in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(error))
        }
        else if let data = data {
          switch (response as? HTTPURLResponse)?.statusCode {
          case 200:
            completion(.success(data))
          case 304:
            completion(.failure(APIClientError.notModified))
          case 422:
            completion(.failure(APIClientError.validationFailed))
          default:
            completion(.failure(APIClientError.unknownError))
          }
        }
        else {
          completion(.failure(APIClientError.unknownError))
        }
      }
    }
    
    task.resume()
  }
  
}
