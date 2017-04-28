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
    
    func updateUser(firstName:UITextField, lastName:UITextField, email:UITextField) -> User? {
        let user = User()
        
        guard let firstNameText = firstName.text, firstNameText != ""
            else {
                showAlert(withTitle: "First Name Not Valid", message: "That is not a valid first name, try again!")
                return nil
        }
        user.firstName = firstNameText
        guard let lastNameText = lastName.text, lastNameText != ""
            else {
                showAlert(withTitle: "Last Name Not Valid", message: "That is not a valid last name, try again!")
                return nil
        }
        user.lastName = lastNameText
        guard let emailText = email.text, emailText != ""
            else {
                showAlert(withTitle: "Email Not Valid", message: "That is not a valid email, try again!")
                return nil
        }
        user.email = emailText
        
        return user
    }
    
    func addBorder(_ view:UIView, cornerRadius:CGFloat = 3) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(colorLiteralRed: 165.0/255.0, green: 0, blue: 0, alpha: 1).cgColor
    }
    
    func addColorPlaceholderText(_ field:UITextField) {
        if let placeholder = field.placeholder {
            field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName:UIColor(colorLiteralRed: 165.0/255.0, green: 0, blue: 0, alpha: 1)])
        }
    }
    
}


protocol KeyboardDismissable {
    func keyboardWasShown(notification: NSNotification)
    func keyboardWillBeHidden(notification: NSNotification)
}

extension UIViewController: UITextFieldDelegate, KeyboardDismissable {
    func keyboardWasShown(notification: NSNotification) {}
    func keyboardWillBeHidden(notification: NSNotification) {}
    
    func hideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func registerKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyboard(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
