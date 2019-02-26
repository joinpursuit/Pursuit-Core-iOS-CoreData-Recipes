//
//  EdamamAPIClient.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

final class EdamamAPIClient {
  static func searchRecipes(keyword: String, completion: @escaping (AppError?, [RecipeInfo]?) -> Void) {
    let endpointURLString = "https://api.edamam.com/search?q=\(keyword)&app_id=\(SecretKeys.AppId)&app_key=\(SecretKeys.APIKey)&from=0&to=50"
    guard let url = URL(string: endpointURLString) else {
      print("bad url: \(endpointURLString)")
      return
    }
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(AppError.networkError(error), nil)
      }
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
        print("bad status code")
        completion(AppError.badStatusCode(statusCode.description), nil)
        return
      }
      if let data = data {
        do {
          let recipeSearch = try JSONDecoder().decode(RecipeSearch.self, from: data)
          let recipes = recipeSearch.hits.map { $0.recipe }
          completion(nil, recipes)
        } catch {
          completion(AppError.jsonDecodingError(error), nil)
        }
      }
    }
    task.resume()
  }
}
