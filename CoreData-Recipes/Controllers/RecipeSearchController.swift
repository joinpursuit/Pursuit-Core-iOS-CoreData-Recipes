//
//  ViewController.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  private var recipes = [RecipeInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    searchBar.delegate = self
    
    searchRecipes(keyword: "salmon")
  }
  
  private func searchRecipes(keyword: String) {
    EdamamAPIClient.searchRecipes(keyword: keyword) { (error, recipes) in
      if let error = error {
        print("searching recipes error: \(error)")
      } else if let recipes = recipes {
        self.recipes = recipes
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      let recipeDetailController = segue.destination as? RecipeDetailController else {
        fatalError("recipeDetailController is nil")
    }
    let recipeInfo = recipes[indexPath.row]
    recipeDetailController.recipeInfo = recipeInfo
  }
}

extension RecipeSearchController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
    let recipe = recipes[indexPath.row]
    cell.textLabel?.text = recipe.label
    cell.detailTextLabel?.text = recipe.source
    return cell
  }
}

extension RecipeSearchController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text,
      !text.isEmpty,
      let searchText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        print("not a a valid search")
        return
    }
    searchRecipes(keyword: searchText)
  }
}
