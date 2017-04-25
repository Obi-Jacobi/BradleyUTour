//
//  Utilities.swift
//  BradleyUTour
//
//  Created by Castor, Alex on 4/25/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import MapKit

// MARK: Helper Extension
extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
