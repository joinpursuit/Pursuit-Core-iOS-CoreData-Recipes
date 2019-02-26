//
//  SavedRecipesController.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreData

class SavedRecipesController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // container from AppDelegate
  private var container = AppDelegate.container
  
  // fetch controller to modifgy the table view based on core data upates
  private var fetchResultsController: NSFetchedResultsController<Recipe>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    configureFetchResultsController()
  }
  
  private func configureFetchResultsController() {
    if let context = container?.viewContext {
      let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
      
      // predicate examples:
      //request.predicate = NSPredicate(format: "ingredientLines contains [c] %@", "beef")
      //request.predicate = NSPredicate(format: "source.name = %@", "Bon Appetit")
      
      fetchResultsController = NSFetchedResultsController(fetchRequest: request,
                                                          managedObjectContext: context,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
      fetchResultsController?.delegate = self
      do {
        try fetchResultsController?.performFetch()
      } catch {
        showAlert(title: "Error fetching data", message: "Try Again", style: .alert)
      }
      tableView.reloadData()
    }
  }
}

extension SavedRecipesController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchResultsController?.sections,
      sections.count > 0 {
      return sections[section].numberOfObjects
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
    if let recipe = fetchResultsController?.object(at: indexPath) {
      cell.textLabel?.text = recipe.label
      cell.detailTextLabel?.text = recipe.source?.name
      cell.imageView?.kf.setImage(with: URL(string: recipe.imageURL!),
                                  placeholder: UIImage(named: "placeholder-image"))
    }
    return cell
  }
}

extension SavedRecipesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if let recipe = fetchResultsController?.object(at: indexPath) {
      container?.viewContext.delete(recipe)
      try? container?.viewContext.save()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

extension SavedRecipesController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections([sectionIndex], with: .fade)
    case .delete:
      tableView.deleteSections([sectionIndex], with: .fade)
    default:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .fade)
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}
