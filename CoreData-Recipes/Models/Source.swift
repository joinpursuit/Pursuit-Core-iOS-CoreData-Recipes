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
  static func createSource(name: String, context: NSManagedObjectContext) throws -> Source {
    let request: NSFetchRequest<Source> = Source.fetchRequest()
    
    // predicate
    request.predicate = NSPredicate(format: "name = %@", name)
    
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
    let source = Source(context: context)
    source.name = name
    
    return source
  }
}
