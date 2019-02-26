//
//  RecipeDetailController.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailController: UIViewController {
  private var context = AppDelegate.container?.viewContext
  public var recipeInfo: RecipeInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = recipeInfo.label
  }
  
  @IBAction func saveRecipeButtonPressed(_ sender: UIBarButtonItem) {
    guard let context = context else {
      return
    }
    AppDelegate.container?.viewContext.perform {
      do {
        let _ = try Recipe.createRecipe(recipeInfo: self.recipeInfo, context: context)
        try context.save()
      } catch {
        print("saving recipe error: \(error)")
      }
    }
  }
}
