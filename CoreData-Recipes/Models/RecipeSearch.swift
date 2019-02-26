//
//  RecipeSearch.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/23/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//
import Foundation

struct RecipeSearch: Codable {
  struct Hits: Codable {
    let recipe: RecipeInfo
  }
  let hits: [Hits]
}

struct RecipeInfo: Codable {
  let uri: String
  let label: String
  let image: String
  let source: String
  let url: String
  let shareAs: String
  let yield: Int
  let dietLabels: [String]
  let healthLabels: [String]
  let ingredientLines: [String]
  let calories: Double
  let totalWeight: Double
  let totalTime: Int
}
