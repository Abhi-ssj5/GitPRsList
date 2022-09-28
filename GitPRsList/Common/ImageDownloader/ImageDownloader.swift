//
//  ImageDownloader.swift
//  GitPRsList
//
//  Created by Abhijeet Choudhary on 29/09/22.
//

import UIKit
import Foundation

enum ImageDownloadError: Error {
  case invalidURL
  case unknownError
}

final class ImageDownloader {
  
  private lazy var operationQueue: OperationQueue = {
    var operationQueue = OperationQueue()
    operationQueue.name = "Git-Image-Downloader"
    operationQueue.maxConcurrentOperationCount = 1
    return operationQueue
  }()
  
  private var cache: [URL: UIImage]
  private var downloadInProgress: [AnyHashable: ImageDownloadOperation] = [:]
  
  public static let shared = ImageDownloader()
  
  init() {
    self.cache = [:]
  }
  
  func downloadImage(_ imageURL: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let url = imageURL else {
      return completion(.failure(ImageDownloadError.invalidURL))
    }
    
    if let image = cache[url] {
      completion(.success(image))
      return
    }
    
    guard downloadInProgress[url] == nil else {
      return
    }
    
    let downloadOperation = ImageDownloadOperation(imageURL: url)
    downloadOperation.completionHandler = { [weak self] (result) in
      guard let self = self else {
        return
      }
      
      self.downloadInProgress.removeValue(forKey: url)
      
      if downloadOperation.isCancelled {
        return
      }
      
      switch result {
      case .success(let image):
        self.cache[url] = image
        completion(.success(image))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    downloadInProgress[url] = downloadOperation
    operationQueue.addOperation(downloadOperation)
  }
  
}

