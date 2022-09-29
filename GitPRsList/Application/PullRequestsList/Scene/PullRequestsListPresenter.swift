//
//  PullRequestsListPresenter.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

final class PullRequestsListPresenterImpl {
  
  // MARK: - Public properties
  
  private struct Defaults {
    static let pageTitle: String = "Closed Pull Request List"
  }
  
  private(set) weak var view: PullRequestsListView?
  var interactor: PullRequestsListInteractor!
  
  // MARK: - Init
  
  init(view: PullRequestsListView?) {
    self.view = view
  }
}

// MARK: - PullRequestsListPresenter methods

extension PullRequestsListPresenterImpl: PullRequestsListPresenter {
  
  func onViewDidLoad() {
    view?.setup(title: Defaults.pageTitle)
    
    view?.showLoader()
    view?.showLoadingBlockerView()
    interactor.getListOfPullRequests(parameter: interactor.getParameters())
  }
  
  func retryButtonTapped() {
    view?.showLoader()
    view?.showLoadingBlockerView()
    interactor.getListOfPullRequests(parameter: interactor.getParameters())
  }
  
  func refreshData() {
    view?.showLoader()
    view?.showLoadingBlockerView()
    interactor.resetPage()
    interactor.getListOfPullRequests(parameter: interactor.getParameters())
  }
  
  func loadMorePullRequests() {
    interactor.getListOfPullRequests(parameter: interactor.getParameters())
  }
  
}

// MARK: - PullRequestsListInteractorOutput methods

extension PullRequestsListPresenterImpl: PullRequestsListInteractorOutput {
  
  func handleGetListOfPullRequestSuccess(response: [PullRequestData]) {
    view?.hideLoader()
    view?.hideLoadingBlockerView()
    view?.showPullRequests(response)
  }
  
  func handleGetListOfPullRequestFailure(error: Error) {
    view?.hideLoader()
    view?.hideLoadingBlockerView()
    view?.showErrorToast(withMessage: error.localizedDescription)
  }
  
  func handleLoadMorePullRequestSuccess(response: [PullRequestData]) {
    view?.loadMorePullRequets(response)
  }
  
  func handleLoadMorePullRequestFailure(error: Error) {
    view?.loadMorePullRequets([])
  }
  
}
