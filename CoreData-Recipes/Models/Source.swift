//
//  Source.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/25/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreData

class Source: NSManagedObject {
  // we need an instance of the ((NSManagedObjectContext)) in order to query, save, update, other crud
  // (create, read, update, delete) functions on the core data database
  static func createSource(name: String, context: NSManagedObjectContext) throws -> Source {
    // to avoid duplicates, we will first search in Core Data for the recipe
    
    // Creating a Fetch Request - Querying Core Data
    // 1. Initialize the NSFetchRequest
    // 2. Assign NSSortDescriptors as needed
    // 3. Configure the NSPredicate
    // 4. Use the NSManagedObjectContext to execute the request
    
    // create a fetch request
    let request: NSFetchRequest<Source> = Source.fetchRequest()
    
    // package request with an array of sort descriptors and a predicate or compound predicate
    // recipeInfo.label "label"
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    request.predicate = NSPredicate(format: "name = %@", name)
    
    var results = [Source]()
    do {
      results = try context.fetch(request)
    } catch {
      throw AppError.fetchingRecipeError(error)
    }
    
    if results.count > 0 {
      throw AppError.sourceDuplicateError("\(name) is already added")
    }
    
    // create a new source
    let source = Source(context: context)
    source.name = name

    return source
  }
}
