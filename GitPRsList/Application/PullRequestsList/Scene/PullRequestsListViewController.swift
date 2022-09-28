//
//  PullRequestsListViewController.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 27/09/22.
//

import UIKit

final class PullRequestsListViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Private properties
  
  private var adapter: PullRequestsListTableViewAdapter?
  
  // MARK: - Public property
  
  var presenter: PullRequestsListPresenter!
  
  // MARK: - LifeCycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    PullRequestsListConfigurator.configure(view: self)
    presenter.onViewDidLoad()
  }
  
}

// MARK: - PullRequestsListView methods

extension PullRequestsListViewController: PullRequestsListView {
  
  func setup(title: String) {
    self.title = title
  }
  
  func showPullRequests(_ array: [PullRequestData]) {
    if let adapter = adapter {
      adapter.refresh(pullRequestArray: array)
    }
    else {
      self.adapter = PullRequestsListTableViewAdapter(tableView: tableView, pullRequestArray: array)
    }
  }
  
  func showLoader() {
    loadingIndicator.startAnimating()
  }
  
  func hideLoader() {
    loadingIndicator.stopAnimating()
  }
  
  func showErrorToast(withMessage message: String) {
    let alertViewController = UIAlertController(title: "Error!",
                                                message: message,
                                                preferredStyle: .alert)
    let retryButton = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
      self?.presenter.retryButtonTapped()
    }
    let okButton = UIAlertAction(title: "Okay", style: .cancel)
    
    alertViewController.addAction(retryButton)
    alertViewController.addAction(okButton)
    self.present(alertViewController, animated: true)
  }
  
}
