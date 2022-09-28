//
//  PullRequestData.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

struct PullRequestData: Decodable, Hashable {
  let id: Int
  let number: Int
  let state: PullRequestState
  let title: String
  let user: User
  let body: String?
  let createdAt: String
  let closedAt: String?
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.number)
  }
  
  static func == (lhs: PullRequestData, rhs: PullRequestData) -> Bool {
    return lhs.number == rhs.number
  }
}

enum PullRequestState: String, Decodable {
  case openPR
  case closedPR
  
  init(from decoder: Decoder) throws {
    let stateType = try decoder.singleValueContainer().decode(String.self)
    
    switch stateType {
    case "open":
      self = .openPR
      
    case "closed":
      self = .closedPR
      
    default:
      self = .closedPR
    }
  }
}

struct User: Decodable {
  let username: String
  let imageURL: String
  
  private enum CodingKeys: String, CodingKey {
    case username = "login"
    case imageURL = "avatarUrl"
  }
}
