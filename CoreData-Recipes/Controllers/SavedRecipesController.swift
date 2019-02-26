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
  
  private var container = AppDelegate.container
  
  private var fetchResultsController: NSFetchedResultsController<Recipe>? // fetches Recipes
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    configureFetchResultsController()
  }
  
  private func configureFetchResultsController() {
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    // predicate
    // use some example predicates
    //request.predicate = NSPredicate(format: "label contains [c] %@", "Salmon")
    
    // sort descriptor
    // use some example sort descriptors
    request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    if let context = container?.viewContext {
      context.perform {
        self.fetchResultsController = NSFetchedResultsController<Recipe>(fetchRequest: request,
                                                                    managedObjectContext: context,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        do {
          try self.fetchResultsController?.performFetch()
        } catch {
          print("fetchResultsController performFetch error: \(error)")
        }
        self.fetchResultsController?.delegate = self
        self.tableView.reloadData()
      }
    }
  }
}

extension SavedRecipesController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: use fetchresultscontroller to get number of objects

    if let sections = fetchResultsController?.sections,
      sections.count > 0 {
      return sections[section].numberOfObjects
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
    // use fetchresultscontroller to get indexpath for current object

    if let recipe = fetchResultsController?.object(at: indexPath) {
      cell.textLabel?.text = recipe.label
      cell.detailTextLabel?.text = recipe.source?.name
    }
    return cell
  }
}


// TODO: make this it's own class (UIViewController) that other classes can subclass from
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
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
    return nil
  }
}
