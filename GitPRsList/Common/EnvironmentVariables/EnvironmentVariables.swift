//
//  EnvironmentVariables.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import Foundation

protocol EnvironmentVariables {
  var baseURL: String { get }
  var gitUsername: String { get }
  var gitRepoName: String { get }
}


struct EnvironmentVariablesImpl: EnvironmentVariables {
  
  // MARK: - Private properties
  
  private let dictionary: [String: Any]
  
  // MARK: - Public properties
  
  public static let shared: EnvironmentVariables = EnvironmentVariablesImpl()
  
  // MARK: - Init
  
  private init() {
    self.dictionary = Bundle.main.infoDictionary ?? [:]
  }
  
  // MARK: - Public properties
  
  var baseURL: String {
    if let baseURL = dictionary["BASE_URL"] as? String {
      return baseURL
    }
    return ""
  }
  
  var gitUsername: String {
    if let username = dictionary["GIT_USERNAME"] as? String {
      return username
    }
    return ""
  }
  
  var gitRepoName: String {
    if let username = dictionary["GIT_REPO_NAME"] as? String {
      return username
    }
    return ""
  }
  
}
