//
//  Recipe.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreData

class Recipe: NSManagedObject {
  // we need an instance of the ((NSManagedObjectContext)) in order to query, save, update, other crud
  // (create, read, update, delete) functions on the core data database
  static func createRecipe(recipeInfo: RecipeInfo, context: NSManagedObjectContext) throws -> Recipe {
    // to avoid duplicates, we will first search in Core Data for the recipe
    
    // Creating a Fetch Request - Querying Core Data
    // 1. Initialize the NSFetchRequest
    // 2. Assign NSSortDescriptors as needed
    // 3. Configure the NSPredicate
    // 4. Use the NSManagedObjectContext to execute the request
    
    // create a fetch request
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    
    // package request with an array of sort descriptors and a predicate or compound predicate
    // recipeInfo.label "label"
    request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
    request.predicate = NSPredicate(format: "label = %@ and source.name = %@", recipeInfo.label, recipeInfo.source)
    
    var results = [Recipe]()
    do {
      results = try context.fetch(request)
    } catch {
      throw AppError.fetchingRecipeError(error)
    }
    
    if results.count > 0 {
      throw AppError.recipeDuplicateError("\(recipeInfo.label) is already added")
    }
    
    // create a new recipe
    let recipe = Recipe(context: context)
    recipe.calories = recipeInfo.calories
    recipe.healthLabels = recipeInfo.healthLabels.joined(separator: ",") // joined() array => String
    recipe.imageURL = recipeInfo.image
    recipe.ingredientLines = recipeInfo.ingredientLines.joined(separator: ",")
    recipe.label = recipeInfo.label
    recipe.yield = Int32(recipeInfo.yield)
    
    // get the source matching the passed in "name" from this method
    do {
      let source = try Source.createSource(name: recipeInfo.source, context: context)
      recipe.source = source // create relationship
    } catch {
      throw AppError.fetchingSourceError
    }
    
    return recipe
  }
}
