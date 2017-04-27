//
//  Utilities.swift
//  BradleyUTour
//
//  Created by Castor, Alex on 4/25/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

// MARK: Helper Extension
extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func updateUser(firstName:UITextField, lastName:UITextField, email:UITextField) -> User {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        
        let user = User()
        if users.count == 0 {
            guard let firstNameText = firstName.text, firstNameText != ""
                else {
                    showAlert(withTitle: "First Name Not Valid", message: "That is not a valid first name, try again!")
                    return User()
            }
            user.firstName = firstNameText
            guard let lastNameText = lastName.text, lastNameText != ""
                else {
                    showAlert(withTitle: "Last Name Not Valid", message: "That is not a valid last name, try again!")
                    return User()
            }
            user.lastName = lastNameText
            guard let emailText = email.text, emailText != ""
                else {
                    showAlert(withTitle: "Email Not Valid", message: "That is not a valid email, try again!")
                    return User()
            }
            user.email = emailText
        }
        return user
    }
    
}
