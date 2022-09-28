//
//  PullRequestsListProtocols.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import UIKit

protocol PullRequestsListView where Self: UIViewController {
  var presenter: PullRequestsListPresenter! { get set }
  
  func showPullRequests(_ array: [PullRequestData])
  func showLoader()
  func hideLoader()
  func showErrorToast(withMessage message: String)
}

protocol PullRequestsListPresenter: AnyObject {
  var view: PullRequestsListView? { get }
  var interactor: PullRequestsListInteractor! { get set }
  
  func onViewDidLoad()
  func retryButtonTapped()
}

protocol PullRequestsListInteractor: AnyObject {
  var output: PullRequestsListInteractorOutput? { get }
  
  func getListOfPullRequests(parameter: PullRequestUseCaseParameter)
}

protocol PullRequestsListInteractorOutput: AnyObject {
  func handleGetListOfPullRequestSuccess(response: [PullRequestData])
  func handleGetListOfPullRequestFailure(error: Error)
}

protocol PullRequestsListConfiguratorInterface {
  static func configure(view: PullRequestsListView)
}
