//
//  PullRequestsListProtocols.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import UIKit

protocol PullRequestsListView where Self: UIViewController {
  var presenter: PullRequestsListPresenter! { get set }
  
  func setup(title: String)
  func showPullRequests(_ array: [PullRequestData])
  func loadMorePullRequets(_ array: [PullRequestData])
  
  func showLoader()
  func hideLoader()
  func showLoadingBlockerView()
  func hideLoadingBlockerView()
  func showErrorToast(withMessage message: String)
}

protocol PullRequestsListPresenter: AnyObject {
  var view: PullRequestsListView? { get }
  var interactor: PullRequestsListInteractor! { get set }
  
  func onViewDidLoad()
  func retryButtonTapped()
  
  func refreshData()
  func loadMorePullRequests()
}

protocol PullRequestsListInteractor: AnyObject {
  var output: PullRequestsListInteractorOutput? { get }
  
  func resetPage()
  func getParameters() -> PullRequestUseCaseParameter
  func getListOfPullRequests(parameter: PullRequestUseCaseParameter)
}

protocol PullRequestsListInteractorOutput: AnyObject {
  func handleGetListOfPullRequestSuccess(response: [PullRequestData])
  func handleGetListOfPullRequestFailure(error: Error)
  
  func handleLoadMorePullRequestSuccess(response: [PullRequestData])
  func handleLoadMorePullRequestFailure(error: Error)
}

protocol PullRequestsListConfiguratorInterface {
  static func configure(view: PullRequestsListView)
}
