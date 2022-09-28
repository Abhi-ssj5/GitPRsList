//
//  PullRequestUseCaseParameter.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

struct PullRequestUseCaseParameter {
  let username: String
  let repoName: String
}

enum PullRequestUseCaseFilterParameter {
  case state(PullRequestQueryState)
  case page(Int)
  case perPage(Int)
}

enum PullRequestQueryState: String {
  case openPRs = "open"
  case closedPRs = "closed"
  case allPRs = "all"
}
