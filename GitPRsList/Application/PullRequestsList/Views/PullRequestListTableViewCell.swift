//
//  PullRequestListTableViewCell.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import UIKit

final class PullRequestListTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var containerView: UIView! {
    didSet {
      containerView.clipsToBounds = true
      containerView.layer.cornerRadius = 4.0
    }
  }
  
  @IBOutlet private weak var userImageView: UIImageView! {
    didSet {
      userImageView.clipsToBounds = true
      userImageView.layer.cornerRadius = 4.0
    }
  }
  
  @IBOutlet private weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
      titleLabel.textColor = UIColor.black
    }
  }
  
  @IBOutlet private weak var subtitleLabel: UILabel! {
    didSet {
      subtitleLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
      subtitleLabel.textColor = UIColor.darkGray
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
  }
  
  func configure(data: PullRequestData) {
    titleLabel.text = data.title
    subtitleLabel.text = getSubTitleText(data: data)
    
    
  }
  
  // MARK: - Privat methods
  
  private func getSubTitleText(data: PullRequestData) -> String {
    var subTitles: [String]
    
    
    
    return subTitles.joined(separator: "\n")
  }
  
}
