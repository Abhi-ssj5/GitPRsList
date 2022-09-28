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
    useCase.getPullRequestList(parameter: parameter, filter: .state(.closedPRs)) { [weak self] (result) in
      guard let self = self else {
        return
      }
      
      switch result {
      case .success(let response):
        self.output?.handleGetListOfPullRequestSuccess(response: response)
        
      case .failure(let error):
        self.output?.handleGetListOfPullRequestFailure(error: error)
      }
    }
  }
  
  func getParameters() -> PullRequestUseCaseParameter {
    return PullRequestUseCaseParameter(username: environmentVariables.gitUsername,
                                       repoName: environmentVariables.gitRepoName)
  }
  
}
