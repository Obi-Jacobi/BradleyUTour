//
//  ChecklistViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/12/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import RealmSwift

class Landmark: Object {
    dynamic var name = ""
    dynamic var visited = false
    dynamic var landmarkDescription = ""
    dynamic var latitude:Double = 0.0
    dynamic var longitude:Double = 0.0
    dynamic var image = NSData()
}

class ChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var visitedLabel: UILabel!
    
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
        
        let realm = try! Realm()
        
        let landmarks = realm.objects(Landmark.self)
        
        if landmarks.count == 0 {
            let populator = LandmarkPopulator()
            populator.populateRealm()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.title = "Checklist"
        
        let realm = try! Realm()
        
        let landmarks = realm.objects(Landmark.self)
        
        var visitedCount = 0
        for landmark in landmarks {
            if landmark.visited {
                visitedCount += 1
            }
        }
        visitedLabel.text = "\(visitedCount)/\(landmarks.count)"
        let progressPercent = Double(visitedCount)/Double(landmarks.count)
        progressBar.progress = Float(progressPercent)
        let progressPercent100 = progressPercent*100
        progressLabel.text = "\(progressPercent100)%"
        
        tableView.reloadData()
        updateProgress()
        updateProgress()
    }
    
    func updateProgress() {
        let barRect = progressBar.frame
        let labelRect = progressLabel.frame
        let barValue = progressBar.progress
        
        let progressWidth = Float(barRect.width) * barValue
        var newLabelRect = labelRect
        newLabelRect.origin.x = CGFloat(progressWidth/2) - (labelRect.width / 2)
        
        progressLabel.frame = newLabelRect
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VisitedSelected" {
            let destination = segue.destination as! LandmarkViewController
            
            let realm = try! Realm()
            let landmarks = realm.objects(Landmark.self)
            
            destination.landmark = landmarks[(tableView.indexPathForSelectedRow?.row)!]
        }
        if segue.identifier == "UnvisitedSelected" {
            let ac = UIAlertController(title: "Unvisited Location", message: "You have not visited this location yet, keep searching!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue) {/*Empty unwindSegue*/}
    
    
    //MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        
        return landmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unvisitedCell = tableView.dequeueReusableCell(withIdentifier: "Unvisited") as! LandmarkUnvisitedTableViewCell
        let visitedCell = tableView.dequeueReusableCell(withIdentifier: "Visited") as! LandmarkVisitedTableViewCell
        
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self).sorted(byKeyPath: "visited", ascending: false)
        
        if landmarks[indexPath.row].visited {
            visitedCell.landmarkName.text = landmarks[indexPath.row].name
            return visitedCell
        }
        else {
            unvisitedCell.landmarkName.text = "???"
            return unvisitedCell
        }
    }

}
