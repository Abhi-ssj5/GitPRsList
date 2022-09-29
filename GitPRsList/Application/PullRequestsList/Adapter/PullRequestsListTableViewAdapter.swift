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

protocol PullRequestsListTableViewAdapterDelegate: AnyObject {
  func refreshData()
  func loadMoreData()
}

final class PullRequestsListTableViewAdapter: NSObject {
  
  // MARK: - Private properties
  
  private struct Defaults {
    static let estimatedRowHeight: CGFloat = 64.0
    static let paginationOffset: CGFloat = 50.0
  }
  
  private let tableView: UITableView
  private var pullRequestArray: [PullRequestData]
  private var dataSource: DataSource!
  private var isPaginating: Bool = false
  
  // MARK: - Public properties
  
  public var delegate: PullRequestsListTableViewAdapterDelegate?
  
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
  
  public func loadMore(pullRequestArray: [PullRequestData]) {
    if !pullRequestArray.isEmpty {
      self.pullRequestArray.append(contentsOf: pullRequestArray)
      
      var snapShot = dataSource.snapshot()
      snapShot.appendItems(pullRequestArray)
      dataSource.defaultRowAnimation = .bottom
      dataSource.apply(snapShot)
    }
    
    self.tableView.tableFooterView = nil
    self.isPaginating = false
  }
  
  // MARK: - Private methods
  
  private func setupTableView() {
    registerCells()
    addPullToRefresh()
    
    tableView.estimatedRowHeight = Defaults.estimatedRowHeight
    configureDataSource()
    tableView.delegate = self
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
    cell.configure(data: PullRequestCellViewModel(model: data))
  }
  
  private func paginatingFooterView() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    spinner.startAnimating()
    return footerView
  }
  
  private func addPullToRefresh() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc private func refreshTableView(_ refreshControl: UIRefreshControl) {
    delegate?.refreshData()
    refreshControl.endRefreshing()
  }
}

// MARK: - UITableViewDelegate methods

extension PullRequestsListTableViewAdapter: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !isPaginating else {
      return
    }
    
    let pos = scrollView.contentOffset.y
    if pos > tableView.contentSize.height - Defaults.paginationOffset - scrollView.frame.size.height {
      self.tableView.tableFooterView = paginatingFooterView()
      self.isPaginating = true
      delegate?.loadMoreData()
    }
  }
  
}
