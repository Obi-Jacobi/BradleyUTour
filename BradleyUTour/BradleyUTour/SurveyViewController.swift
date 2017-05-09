//
//  SurveyViewController.swift
//  BradleyUTour
//
//  Created by Ethan Ronne on 5/8/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import RealmSwift

class SurveyViewController: UIViewController {

    //Steppers
    @IBOutlet weak var useStepper: UIStepper!
    @IBOutlet weak var easeStepper: UIStepper!
    @IBOutlet weak var performStepper: UIStepper!
    @IBOutlet weak var funStepper: UIStepper!
    
    //Labels
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var easeLabel: UILabel!
    @IBOutlet weak var performLabel: UILabel!
    @IBOutlet weak var funLabel: UILabel!
    
    @IBOutlet var submitButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBorder(submitButton, cornerRadius: 15)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func useStepperPressed(_ sender: Any) {
        useLabel.text = "\(Int(useStepper.value))/5"
    }
    
    @IBAction func easeStepperPressed(_ sender: Any) {
        easeLabel.text = "\(Int(easeStepper.value))/5"
    }
    
    @IBAction func performStepperPressed(_ sender: Any) {
        performLabel.text = "\(Int(performStepper.value))/5"
    }
    
    @IBAction func funStepperPressed(_ sender: Any) {
        funLabel.text = "\(Int(funStepper.value))/5"
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let realm = try! Realm()
        let surveyResponse = "\(Int(useStepper.value))\(Int(useStepper.value))\(Int(performStepper.value))\(Int(funStepper.value))"
        
        //print(surveyResponse)
        
        let users = realm.objects(User.self)
    
        try! realm.write {
                users[0].surveyResponse = surveyResponse
        }
        
        performSegue(withIdentifier: "unwindToSettings", sender: self)
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
