//
//  RewardsViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/12/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import RealmSwift

class RewardsViewController: UIViewController {
    
    @IBOutlet var rewards: [UIView]!
    
    let dict = [0:"BU", 1:"Kaboom", 2:"Angry", 3:"Happy", 4:"Love", 5:"Normal", 6:"Shocked", 7:"Winking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, reward) in rewards.enumerated() {
            addBorder(reward, cornerRadius: 50)
            
            let subviews = reward.subviews as! [UIImageView]
            let imageView = subviews.first
            
            let realm = try! Realm()
            let landmarks = realm.objects(Landmark.self)
            
            let landmark = landmarks[index]
            
            var imageName = "Lock"
            var tempName = ""
            
            if let value = dict[index] {
                tempName = value
            }
            if landmark.visited {
                imageName = tempName
            }
            imageView?.image = UIImage(named: imageName)
            
            imageView?.sizeToFit()
            imageView?.removeConstraints((imageView?.constraints)!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for (index, reward) in rewards.enumerated() {
            addBorder(reward, cornerRadius: 50)
            
            let subviews = reward.subviews as! [UIImageView]
            let imageView = subviews.first
            
            let realm = try! Realm()
            let landmarks = realm.objects(Landmark.self)
            
            let landmark = landmarks[index]
            
            var imageName = "Lock"
            var tempName = ""
            
            if let value = dict[index] {
                tempName = value
            }
            if landmark.visited {
                imageName = tempName
                //imageView?.image = UIImage(named: imageName)
            }
            imageView?.image = UIImage(named: imageName)
            
            /*
            imageView?.sizeToFit()
            imageView?.removeConstraints((imageView?.constraints)!)
             */
        }
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
