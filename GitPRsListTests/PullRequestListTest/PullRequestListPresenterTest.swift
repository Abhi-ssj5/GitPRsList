//
//  PullRequestListPresenterTest.swift
//  GitPRsListTests
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import XCTest
@testable import GitPRsList

final class PullRequestListPresenterTest: XCTestCase {
  
  var sut: PullRequestsListPresenterImpl?
  
  var mockView: MockPullRequestListView!
  var mockInteractor: MockPullRequestListInteractor!
  var mockFactory: MockFactory!
  
  override func setUp() {
    super.setUp()
    
    mockView = MockPullRequestListView()
    mockInteractor = MockPullRequestListInteractor()
    mockFactory = MockFactory()
    
    sut = PullRequestsListPresenterImpl(view: mockView)
    sut?.interactor = mockInteractor
  }
  
  override func tearDown() {
    sut = nil
    mockView = nil
    mockInteractor = nil
    mockFactory = nil
    super.tearDown()
  }
  
  func testSetupTitleOnViewDidLoad() {
    sut?.onViewDidLoad()
    XCTAssertTrue(mockView.isSetupTitleCalled)
  }
  
  func testShowLoaderOnViewDidLoad() {
    sut?.onViewDidLoad()
    XCTAssertTrue(mockView.isShowLoaderCalled)
  }
  
  func testShowLoadingBlockerViewOnViewDidLoad() {
    sut?.onViewDidLoad()
    XCTAssertTrue(mockView.isShowLoadingBlockerViewCalled)
  }
  
  func testGetListOfPullRequestsOnViewDidLoad() {
    sut?.onViewDidLoad()
    XCTAssertTrue(mockInteractor.getListOfPullRequestsCalled)
  }
  
  func testShowLoaderOnRetryButtonTapped() {
    sut?.retryButtonTapped()
    XCTAssertTrue(mockView.isShowLoaderCalled)
  }
  
  func testShowLoadingBlockerViewOnRetryButtonTapped() {
    sut?.retryButtonTapped()
    XCTAssertTrue(mockView.isShowLoadingBlockerViewCalled)
  }
  
  func testGetListOfPullRequestsOnRetryButtonTapped() {
    sut?.retryButtonTapped()
    XCTAssertTrue(mockInteractor.getListOfPullRequestsCalled)
  }
  
  func testShowLoaderOnRefreshData() {
    sut?.refreshData()
    XCTAssertTrue(mockView.isShowLoaderCalled)
  }
  
  func testShowLoadingBlockerViewOnRefreshData() {
    sut?.refreshData()
    XCTAssertTrue(mockView.isShowLoadingBlockerViewCalled)
  }
  
  func testResetPageOnRefreshData() {
    sut?.refreshData()
    XCTAssertTrue(mockInteractor.isResetPageCalled)
  }
  
  func testGetListOfPullRequestsOnRefreshData() {
    sut?.refreshData()
    XCTAssertTrue(mockInteractor.getListOfPullRequestsCalled)
  }
  
  func testGetListOfPullRequestsOnLoadMorePullRequests() {
    sut?.loadMorePullRequests()
    XCTAssertTrue(mockInteractor.getListOfPullRequestsCalled)
  }
  
  func testHideLoaderOnHandleGetListOfPullRequestSuccess() {
    do {
      let response = try mockFactory.getPullRequestArray()
      sut?.handleGetListOfPullRequestSuccess(response: response)
      XCTAssertTrue(mockView.isHideLoaderCalled)
    }
    catch {
      XCTFail()
    }
  }
  
  func testHideLoadingBlockerViewOnHandleGetListOfPullRequestSuccess() {
    do {
      let response = try mockFactory.getPullRequestArray()
      sut?.handleGetListOfPullRequestSuccess(response: response)
      XCTAssertTrue(mockView.isHideLoadingBlockerViewCalled)
    }
    catch {
      XCTFail()
    }
  }
  
  func testShowPullRequestsOnHandleGetListOfPullRequestSuccess() {
    do {
      let response = try mockFactory.getPullRequestArray()
      sut?.handleGetListOfPullRequestSuccess(response: response)
      XCTAssertTrue(mockView.isShowPullRequestCalled)
    }
    catch {
      XCTFail()
    }
  }
  
  func testHideLoaderOnHandleGetListOfPullRequestFailure() {
    sut?.handleGetListOfPullRequestFailure(error: MockFactoryError.requestFailed)
    XCTAssertTrue(mockView.isHideLoaderCalled)
  }
  
  func testHideLoadingBlockerViewOnHandleGetListOfPullRequestFailure() {
    sut?.handleGetListOfPullRequestFailure(error: MockFactoryError.requestFailed)
    XCTAssertTrue(mockView.isHideLoadingBlockerViewCalled)
  }
  
  func testShowErrorToastOnHandleGetListOfPullRequestFailure() {
    sut?.handleGetListOfPullRequestFailure(error: MockFactoryError.requestFailed)
    XCTAssertEqual(MockFactoryError.requestFailed.localizedDescription, mockView.errorToastMessage)
  }
  
  func testLoadMorePullRequestOnHandleLoadMorePullRequestSuccess() {
    do {
      let response = try mockFactory.getPullRequestArray()
      sut?.handleLoadMorePullRequestSuccess(response: response)
      XCTAssertTrue(mockView.isLoadMorePullRequestCalled)
    }
    catch {
      XCTFail()
    }
  }
  
  func testLoadMorePullRequestOnHandleLoadMorePullRequestFailure() {
    sut?.handleLoadMorePullRequestFailure(error: MockFactoryError.requestFailed)
    XCTAssertTrue(mockView.isLoadMorePullRequestCalled)
  }
  
}

final class MockPullRequestListView: UIViewController, PullRequestsListView {
  var isSetupTitleCalled: Bool = false
  var isShowPullRequestCalled: Bool = false
  var isLoadMorePullRequestCalled: Bool = false
  var isShowLoaderCalled: Bool = false
  var isHideLoaderCalled: Bool = false
  var isShowLoadingBlockerViewCalled: Bool = false
  var isHideLoadingBlockerViewCalled: Bool = false
  var errorToastMessage: String?
  
  var presenter: PullRequestsListPresenter!
  
  func setup(title: String) {
    self.isSetupTitleCalled = true
  }
  
  func showPullRequests(_ array: [PullRequestData]) {
    self.isShowPullRequestCalled = true
  }
  
  func loadMorePullRequets(_ array: [PullRequestData]) {
    self.isLoadMorePullRequestCalled = true
  }
  
  func showLoader() {
    self.isShowLoaderCalled = true
  }
  
  func hideLoader() {
    self.isHideLoaderCalled = true
  }
  
  func showLoadingBlockerView() {
    self.isShowLoadingBlockerViewCalled = true
  }
  
  func hideLoadingBlockerView() {
    self.isHideLoadingBlockerViewCalled = true
  }
  
  func showErrorToast(withMessage message: String) {
    self.errorToastMessage = message
  }
  
}

final class MockPullRequestListInteractor: PullRequestsListInteractor {
  
  var output: PullRequestsListInteractorOutput?
  private let mockFactory = MockFactory()
  var getListOfPullRequestsCalled: Bool = false
  var isResetPageCalled: Bool = false
  
  func resetPage() {
    self.isResetPageCalled = true
  }
  
  func getParameters() -> PullRequestUseCaseParameter {
    return mockFactory.getParameter()
  }
  
  func getListOfPullRequests(parameter: PullRequestUseCaseParameter) {
    self.getListOfPullRequestsCalled = true
  }
}

enum MockFactoryError: Error {
  case invalidPath
  case requestFailed
}

final class MockFactory: NSObject {
  
  func getParameter() -> PullRequestUseCaseParameter {
    return PullRequestUseCaseParameter(username: "MockUsername", repoName: "MockRepoName")
  }
  
  func getPullRequestArray() throws -> [PullRequestData] {
    let bundle = Bundle(for: type(of: self))
    guard let path = bundle.path(forResource: "Pulls", ofType: "json") else {
      throw MockFactoryError.invalidPath
    }
    
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let response = try decoder.decode([PullRequestData].self, from: data)
      return response
    }
    catch let decodingError{
      throw decodingError
    }
  }
  
}
