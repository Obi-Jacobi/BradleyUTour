//
//  ProfileViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/27/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet var editButton:UIButton!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var scrollView:UIScrollView!
    var activeField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboard()
        hideKeyboardWhenTapped()
        
        let realm = try! Realm()
        let users = realm.objects(User.self)
        
        if users.count > 0 {
            let user = users[0]
            
            firstNameField.text = user.firstName
            lastNameField.text = user.lastName
            emailField.text = user.email
        }

        // Do any additional setup after loading the view.
    }
    
    func saveUser() {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        
        let user = updateUser(firstName: firstNameField, lastName: lastNameField, email: emailField)
        if let user = user {
            try! realm.write {
                users[0].firstName = user.firstName
                users[0].lastName = user.lastName
                users[0].email = user.email
            }
        }
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        saveUser()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDismissing stuff
    override func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    override func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.endEditing(true)
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
