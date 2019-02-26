//
//  RecipeDetailController.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class RecipeDetailController: UIViewController {
  @IBOutlet weak var recipeImageView: UIImageView!
  
  private var context = AppDelegate.container?.viewContext
  public var recipeInfo: RecipeInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  private func updateUI() {
    navigationItem.title = recipeInfo.label
    // more here: https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet
    recipeImageView.kf.indicatorType = .activity
    recipeImageView.kf.setImage(with: URL(string: recipeInfo.image), placeholder: UIImage(named: "placeholder-image"))
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
