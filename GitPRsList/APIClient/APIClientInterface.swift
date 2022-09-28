//
//  APIClientInterface.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import Foundation


protocol APIClientInterface {
  func getPullRequests(username: String,
                       repo: String,
                       filters: [(name: String, value: String)],
                       completion: @escaping (Result<Data, Error>) -> Void)
}
