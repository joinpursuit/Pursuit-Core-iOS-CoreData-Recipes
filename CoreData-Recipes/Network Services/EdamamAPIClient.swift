//
//  EdamamAPIClient.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

final class EdamamAPIClient {
  static func searchRecipes(keyword: String, completion: @escaping (Error?, [RecipeInfo]?) -> Void) {
    let endpointURLString = "https://api.edamam.com/search?q=\(keyword)&app_id=\(SecretKeys.AppId)&app_key=\(SecretKeys.APIKey)&from=0&to=50"
    guard let url = URL(string: endpointURLString) else {
      print("bad url: \(endpointURLString)")
      return
    }
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(error, nil)
      }
      guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode) else {
        print("bad status code")
          // TODO: handle case
        return
      }
      if let data = data {
        do {
          let recipeSearch = try JSONDecoder().decode(RecipeSearch.self, from: data)
          let recipes = recipeSearch.hits.map { $0.recipe }
          completion(nil, recipes)
        } catch {
          completion(error, nil)
        }
      }
    }
    task.resume()
  }
}
