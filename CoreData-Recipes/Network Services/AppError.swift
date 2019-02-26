//
//  AppError.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/26/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

enum AppError: Error {
  case recipeDuplicateError(String)
  case sourceDuplicateError(String)
  case fetchingSourceError
  case fetchingRecipeError(Error)
  case badStatusCode(String)
  case networkError(Error)
  case jsonDecodingError(Error)
  
  func errorMessage() -> String {
    switch self {
    case .recipeDuplicateError (let message):
      return NSLocalizedString(message, comment: "Recipe Duplicate Error")
    case .sourceDuplicateError (let message):
      return NSLocalizedString(message, comment: "Source Duplicate Error")
    case .fetchingSourceError:
      return NSLocalizedString("Fetching Source Error", comment: "Fetching Source Error")
    case .fetchingRecipeError:
      return NSLocalizedString("Fetching Recipe Error", comment: "Fetching Recipe Error")
    case .badStatusCode (let message):
      return NSLocalizedString(message, comment: "Bad Status Code")
    case .networkError (let err):
      return NSLocalizedString(err.localizedDescription, comment: "Network Error")
    case .jsonDecodingError (let err):
      return ("\(err)")
    }
  }
}
