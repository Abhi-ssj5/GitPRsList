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
      userImageView.backgroundColor = UIColor.lightGray
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
  
  // MARK: - LifeCycle method
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
  }
  
  // MARK: - Public methods
  
  func configure(data: PullRequestCellViewModel) {
    titleLabel.text = data.title
    subtitleLabel.text = data.subTitle
    
    ImageDownloader.shared.downloadImage(data.userImageURL, completion: { [weak self] (result) in
      if let image = try? result.get() {
        DispatchQueue.main.async { [weak self] in
          self?.userImageView.image = image
        }
      }
    })
  }
  
}
