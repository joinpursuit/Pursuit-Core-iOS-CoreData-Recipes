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
  
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var ingredientsLabel: UILabel!
  
  private var container = AppDelegate.container
  public var recipeInfo: RecipeInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = recipeInfo.label
    updateUI()
  }
  
  private func updateUI() {
    recipeImageView.kf.indicatorType = .activity
    recipeImageView.kf.setImage(with: URL(string: recipeInfo.image), placeholder: UIImage(named: "placeholder-image"))
    
    let sentences = recipeInfo.ingredientLines.map { $0.replacingOccurrences(of: ",", with: "") }
                                              .map { $0 + "\n" }
    let ingredients = sentences.joined()
    ingredientsLabel.text = ingredients
  }
  
  @IBAction func saveRecipeButtonPressed(_ sender: UIBarButtonItem) {
    print("saved button pressed")
    
    // create recipe
    
    if let context = container?.viewContext {
      do {
        let _ = try Recipe.createRecipe(recipeInfo: recipeInfo, context: context)
        
        //======================================
        // PLEASE REMEMEBER TO SAVE THE CONTEXT
        //======================================
        try? context.save()
        navigationItem.rightBarButtonItem?.isEnabled = false
        showAlert(title: "Saved", message: "\(recipeInfo.label) was saved", style: .alert)
      } catch {
        showAlert(title: "Error Saving Recipe", message: (error as! AppError).errorMessage(), style: .alert)
      }
    }
    
    
  }
}
