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
  static func createRecipe(recipeInfo: RecipeInfo, context: NSManagedObjectContext) throws -> Recipe {
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    
    // predicate
    request.predicate = NSPredicate(format: "label = %@ and source.name = %@", recipeInfo.label, recipeInfo.source)
    
    // sort descriptor
    
    // execute fetch to see if there already exist a recipe record
    do {
      let results = try context.fetch(request)
      if results.count > 0 {
        return results[0]
      }
    } catch {
      throw error
    }
    
    // create a new record
    let recipe = Recipe(context: context)
    recipe.calories = recipeInfo.calories
    recipe.healthLabels = recipeInfo.healthLabels.joined(separator: ",")
    recipe.imageURL = recipeInfo.image
    recipe.ingredientLines = recipeInfo.ingredientLines.joined(separator: ",")
    recipe.label = recipeInfo.label
    recipe.label = recipeInfo.label
    
    // create the relationship 
    do {
      let source = try Source.createSource(name: recipeInfo.source, context: context)
      recipe.source = source
    } catch {
      throw error
    }
    
    return recipe
  }
}
