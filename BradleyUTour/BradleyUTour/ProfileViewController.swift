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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        try! realm.write {
            users[0].firstName = user.firstName
            users[0].lastName = user.lastName
            users[0].email = user.email
        }
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        saveUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
