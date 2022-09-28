//
//  PullRequestsListConfigurator.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 28/09/22.
//

import Foundation

struct PullRequestsListConfigurator: PullRequestsListConfiguratorInterface {
  
  static func configure(view: PullRequestsListView) {
    let presenter = PullRequestsListPresenterImpl(view: view)
    
    let apiClient: APIClientInterface = APIClient.shared
    let useCase: PullRequestUseCase = PullRequestUseCaseImpl(apiClient: apiClient)
    let interactor: PullRequestsListInteractor = PullRequestsListInteractorImpl(output: presenter,
                                                                                useCase: useCase)
    
    view.presenter = presenter
    presenter.interactor = interactor
  }
  
}
