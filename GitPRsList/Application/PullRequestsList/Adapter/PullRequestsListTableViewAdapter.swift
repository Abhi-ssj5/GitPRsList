//
//  PullRequestsListTableViewAdapter.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import UIKit

fileprivate typealias DataSource = UITableViewDiffableDataSource<SectionType, PullRequestData>
fileprivate typealias SnapShot = NSDiffableDataSourceSnapshot<SectionType, PullRequestData>

fileprivate enum SectionType {
  case pullRequest
}

final class PullRequestsListTableViewAdapter: NSObject {
  
  // MARK: - Private properties
  
  private struct Defaults {
    static let estimatedRowHeight: CGFloat = 64.0
  }
  
  private let tableView: UITableView
  private var pullRequestArray: [PullRequestData]
  private var dataSource: DataSource!
  private var estimatedHeight: [IndexPath: CGFloat] = [:]
  
  // MARK: - Init
  
  init(tableView: UITableView,
       pullRequestArray: [PullRequestData]) {
    self.tableView = tableView
    self.pullRequestArray = pullRequestArray
    
    super.init()
    setupTableView()
  }
  
  // MARK: - Public methods
  
  public func refresh(pullRequestArray: [PullRequestData]) {
    self.pullRequestArray = pullRequestArray
    dataSource.apply(getSnapShot())
  }
  
  // MARK: - Private methods
  
  private func setupTableView() {
    registerCells()
    
    tableView.estimatedRowHeight = Defaults.estimatedRowHeight
    tableView.delegate = self
    
    configureDataSource()
  }
  
  private func registerCells() {
    let xNib = UINib(nibName: String(describing: PullRequestListTableViewCell.self), bundle: nil)
    tableView.register(xNib, forCellReuseIdentifier: String(describing: PullRequestListTableViewCell.self))
  }
  
  private func configureDataSource() {
    let cellProvider: (UITableView, IndexPath, PullRequestData) -> UITableViewCell? = { [weak self] (tableView, indexPath, data) in
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PullRequestListTableViewCell.self), for: indexPath)
      self?.configureCell(cell as? PullRequestListTableViewCell, data: data, indexPath: indexPath)
      return cell
    }
    
    dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
    
    dataSource.apply(getSnapShot())
  }
  
  private func getSnapShot() -> SnapShot {
    var snapShot = SnapShot()
    snapShot.appendSections([.pullRequest])
    snapShot.appendItems(pullRequestArray, toSection: .pullRequest)
    return snapShot
  }
  
  private func configureCell(_ cell: PullRequestListTableViewCell?, data: PullRequestData, indexPath: IndexPath) {
    guard let cell = cell else {
      return
    }
    cell.configure(data: data)
  }
}

// MARK: - UITableViewDelegate methods

extension PullRequestsListTableViewAdapter: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    estimatedHeight[indexPath] = cell.contentView.frame.height
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return estimatedHeight[indexPath] ?? Defaults.estimatedRowHeight
  }
  
}
