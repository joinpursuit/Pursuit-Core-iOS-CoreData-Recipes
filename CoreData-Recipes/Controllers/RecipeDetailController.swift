//
//  RecipeDetailController.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeDetailController: UIViewController {
  
  public var recipeInfo: RecipeInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = recipeInfo.label
  }
  
  @IBAction func saveRecipeButtonPressed(_ sender: UIBarButtonItem) {
    print("saved button pressed")
  }
}
