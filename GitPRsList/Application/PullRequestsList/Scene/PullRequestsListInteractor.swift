//
//  PullRequestsListInteractor.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

final class PullRequestsListInteractorImpl {
  
  // MARK: - Private properties
  
  private(set) weak var output: PullRequestsListInteractorOutput?
  private let useCase: PullRequestUseCase
  private let environmentVariables: EnvironmentVariables
  private var page: Int = 0
  private let pageSize: Int = 10
  
  private var pullRequestArray: [PullRequestData]?
  
  // MARK: - Init
  
  init(output: PullRequestsListInteractorOutput?,
       useCase: PullRequestUseCase,
       environmentVariables: EnvironmentVariables) {
    self.output = output
    self.useCase = useCase
    self.environmentVariables = environmentVariables
  }
  
}

// MARK: - PullRequestsListInteractor methods

extension PullRequestsListInteractorImpl: PullRequestsListInteractor {
  
  func getListOfPullRequests(parameter: PullRequestUseCaseParameter) {
    useCase.getPullRequestList(parameter: parameter,
                               filter: .state(.closedPRs), .page(page), .perPage(pageSize)) { [weak self] (result) in
      guard let self = self else {
        return
      }
      
      switch result {
      case .success(let response):
        if self.page == 0 {
          self.pullRequestArray = response
          self.output?.handleGetListOfPullRequestSuccess(response: response)
        }
        else if var pullRequestArray = self.pullRequestArray {
          pullRequestArray.append(contentsOf: response)
          self.pullRequestArray = pullRequestArray
          self.output?.handleLoadMorePullRequestSuccess(response: response)
        }
        self.page += 1
        
      case .failure(let error):
        if self.page == 0 {
          self.output?.handleGetListOfPullRequestFailure(error: error)
        }
        else {
          self.output?.handleLoadMorePullRequestFailure(error: error)
        }
      }
    }
  }
  
  func getParameters() -> PullRequestUseCaseParameter {
    return PullRequestUseCaseParameter(username: environmentVariables.gitUsername,
                                       repoName: environmentVariables.gitRepoName)
  }
  
  func resetPage() {
    self.page = 0
  }
  
}
