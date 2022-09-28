//
//  APIClientError.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

enum APIClientError: Error {
  case invalidURL
  case unknownError
  case notModified
  case validationFailed
}
