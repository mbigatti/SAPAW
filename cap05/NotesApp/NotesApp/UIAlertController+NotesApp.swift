//
//  UIAlertController+NotesApp.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 26/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func presentPersistenceErrorAlert(viewController: UIViewController) {
        let alertController = UIAlertController(title: kAppTitle, message: kPersistenceErrorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: kOKButtonTitle, style: .Default, handler: nil)
        alertController.addAction(okAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
