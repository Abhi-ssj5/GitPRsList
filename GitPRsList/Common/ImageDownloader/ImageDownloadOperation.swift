//
//  ImageDownloadOperation.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import UIKit
import Foundation

final class ImageDownloadOperation: Operation {
  
  // MARK: - Private properties
  
  private enum OperationState {
    case ready
    case executing
    case finished
  }
  
  private var state: OperationState = .ready {
    willSet {
      self.willChangeValue(forKey: "isExecuting")
      self.willChangeValue(forKey: "isFinished")
    }
    didSet {
      self.didChangeValue(forKey: "isExecuting")
      self.didChangeValue(forKey: "isFinished")
    }
  }
  
  private let imageURL: URL
  private var urlSessionTask: URLSessionDataTask?
  
  // MARK: - Public properties
  
  override var isReady: Bool { return state == .ready }
  override var isExecuting: Bool { return state == .executing }
  override var isFinished: Bool { return state == .finished }
  
  public var completionHandler: ((Result<UIImage, Error>) -> Void)?
  
  // MARK: - Init
  
  init(imageURL: URL) {
    self.imageURL = imageURL
  }
  
  override func main() {
    if isCancelled {
      state = .finished
      completionHandler?(.failure(ImageDownloadError.unknownError))
      return
    }
    
    self.state = .executing
    self.urlSessionTask = downloadTask(imageURL: self.imageURL)
  }
  
  override func cancel() {
    super.cancel()
    
    state = .finished
    urlSessionTask?.cancel()
    completionHandler?(.failure(ImageDownloadError.unknownError))
  }
  
  private func downloadTask(imageURL: URL) -> URLSessionDataTask {
    let urlRequest = URLRequest(url: imageURL)
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
      if let error = error {
        self?.state = .finished
        self?.completionHandler?(.failure(error))
      }
      else if let data = data,
              let image = UIImage(data: data) {
        self?.state = .finished
        self?.completionHandler?(.success(image))
      }
      else {
        self?.state = .finished
        self?.completionHandler?(.failure(ImageDownloadError.unknownError))
      }
    }
    
    task.resume()
    return task
  }
  
}
