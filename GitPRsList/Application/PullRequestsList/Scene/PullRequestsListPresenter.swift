//
//  PullRequestsListPresenter.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

final class PullRequestsListPresenterImpl {
  
  // MARK: - Public properties
  
  private(set) weak var view: PullRequestsListView?
  var interactor: PullRequestsListInteractor!
  
  // MARK: - Private properties
  
  private lazy var parameter = PullRequestUseCaseParameter(username: "Abhi-ssj5", repoName: "CalendarSync")
  
  // MARK: - Init
  
  init(view: PullRequestsListView?) {
    self.view = view
  }
}

// MARK: - PullRequestsListPresenter methods

extension PullRequestsListPresenterImpl: PullRequestsListPresenter {
  
  func onViewDidLoad() {
    view?.showLoader()
    interactor.getListOfPullRequests(parameter: parameter)
  }
  
  func retryButtonTapped() {
    view?.showLoader()
    interactor.getListOfPullRequests(parameter: parameter)
  }
  
}

// MARK: - PullRequestsListInteractorOutput methods

extension PullRequestsListPresenterImpl: PullRequestsListInteractorOutput {
  
  func handleGetListOfPullRequestSuccess(response: [PullRequestData]) {
    view?.hideLoader()
    view?.showPullRequests(response)
  }
  
  func handleGetListOfPullRequestFailure(error: Error) {
    view?.hideLoader()
    view?.showErrorToast(withMessage: error.localizedDescription)
  }
  
}
