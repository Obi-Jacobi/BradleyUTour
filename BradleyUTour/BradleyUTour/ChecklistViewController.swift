//
//  ChecklistViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/12/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var tableView:UITableView!
    
    // This is how you call it to reload the progress label location 
    /*
    @IBAction func test(_ sender: Any) {
        let thing = sender as! UIStepper
        let value = thing.value
        
        progressBar.progress = Float(value)/10
        viewDidLayoutSubviews()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let barRect = progressBar.frame
        let labelRect = progressLabel.frame
        let barValue = progressBar.progress
        
        let progressWidth = Float(barRect.width) * barValue
        var newLabelRect = labelRect
        newLabelRect.origin.x = CGFloat(progressWidth/2) - (labelRect.width / 2)
        //newLabelRect.midX
       
        
        progressLabel.frame = newLabelRect
        
        /*
        print(barRect)
        print(progressWidth)
        print(labelRect)
        print(labelRect.width)
        print(newLabelRect)
        print(newLabelRect.midX)*/
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
    
    //MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Unvisited")
        
        return cell!
    }

}
