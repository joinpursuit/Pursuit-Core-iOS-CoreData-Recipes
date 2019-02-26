//
//  UIViewController+Alerts.swift
//  CoreData-Recipes
//
//  Created by Alex Paul on 2/26/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController {
  public func showAlert(title: String?, message: String?, style: UIAlertController.Style) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let okAction = UIAlertAction(title: "Ok", style: .default)
    alertController.addAction(okAction)
    present(alertController, animated: true)
  }
  
  // add more types of alerts
}
