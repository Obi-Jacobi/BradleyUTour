//
//  RewardsViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/12/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {
    
    @IBOutlet var rewards: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, reward) in rewards.enumerated() {
            reward.layer.cornerRadius = 50
            
            let subviews = reward.subviews as! [UIImageView]
            let imageView = subviews.first
            
            if index == 0 {
                imageView?.image = UIImage(named: "BU")
            }
            else if index == 1 {
                imageView?.image = UIImage(named: "Kaboom")
            }
            else {
                imageView?.image = UIImage(named: "Lock")
            }
            imageView?.sizeToFit()
            imageView?.removeConstraints((imageView?.constraints)!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Rewards"
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
