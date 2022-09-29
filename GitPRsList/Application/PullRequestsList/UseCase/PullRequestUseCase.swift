//
//  PullRequestUseCase.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 27/09/22.
//

import Foundation

protocol PullRequestUseCase {
  func getPullRequestList(parameter: PullRequestUseCaseParameter,
                          filter: PullRequestUseCaseFilterParameter...,
                          completion: @escaping (Result<[PullRequestData], Error>) -> Void)
}

struct PullRequestUseCaseImpl: PullRequestUseCase {
  
  // MARK: - Private property
  
  private struct Filters {
    static let state: String = "state"
    static let page: String = "page"
    static let perPage: String = "per_page"
  }
  
  private let apiClient: APIClientInterface
  
  // MARK: - Init
  
  init(apiClient: APIClientInterface) {
    self.apiClient = apiClient
  }
  
  // MARK: - PullRequestUseCase methods
  
  func getPullRequestList(parameter: PullRequestUseCaseParameter,
                          filter: PullRequestUseCaseFilterParameter...,
                          completion: @escaping (Result<[PullRequestData], Error>) -> Void) {
    let filters: [(String, String)] = filter.map({ (element) in
      switch element {
      case .state(let state):
        return (Filters.state, state.rawValue)
        
      case .page(let pageNumber):
        return (Filters.page, String(format: "%d", pageNumber))
        
      case .perPage(let perPageCount):
        return (Filters.perPage, String(format: "%d", perPageCount))
      }
    })
    
    apiClient.getPullRequests(username: parameter.username, repo: parameter.repoName, filters: filters) { (result) in
      
      switch result {
      case .success(let data):
        do {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let response = try decoder.decode([PullRequestData].self, from: data)
          completion(.success(response))
        }
        catch let decodingError {
          completion(.failure(decodingError))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
