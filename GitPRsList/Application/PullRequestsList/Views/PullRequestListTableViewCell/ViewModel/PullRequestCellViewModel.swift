//
//  PullRequestCellViewModel.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import Foundation

struct PullRequestCellViewModel {
  
  // MARK: - Publi properties
  
  let title: String
  let subTitle: String
  let userImageURL: URL
  
  // MARK: - Init
  
  init(model: PullRequestData) {
    self.title = model.title
    self.subTitle = Self.getSubTitleText(data: model)
    self.userImageURL = model.user.imageURL
  }
  
  // MARK: - Private metehods
  
  private static func getSubTitleText(data: PullRequestData) -> String {
    var subTitles: [String] = []
    subTitles.append(String(format: "by %@", data.user.username))
    
    if let createdAt = getFormattedDate(from: data.createdAt) {
      subTitles.append(String(format: "opened on %@", createdAt))
    }
    
    if let closedAt = data.closedAt,
       let formattedString = getFormattedDate(from: closedAt) {
      subTitles.append(String(format: "closed on %@", formattedString))
    }
    return subTitles.joined(separator: "\n")
  }
  
  private static func getFormattedDate(from string: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    guard let date = dateFormatter.date(from: string) else { return nil }
    
    let requiredFormat = DateFormatter()
    requiredFormat.dateFormat = "dd MMM yyyy"
    
    return requiredFormat.string(from: date)
  }
  
}
