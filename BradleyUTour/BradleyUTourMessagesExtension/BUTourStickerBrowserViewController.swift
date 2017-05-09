//
//  BUTourStickerBrowserViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 5/8/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import Messages
import RealmSwift

class BUTourStickerBrowserViewController: MSStickerBrowserViewController {
    
    let dict = ["Founder's Circle":"TestSticker1", "Bradley Hall":"TestSticker2", "Caterpillar GCC":"kaboom_angry", "Jobst Hall":"kaboom_happy", "Westlake Hall":"kaboom_love", "Baker Hall":"kaboom_normal", "Michel Student Center":"kaboom_shocked", "Cullom-Davis Library":"kaboom_winking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let newView = MSStickerBrowserView(
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        
        let landmarks = realm.objects(Landmark.self)
        
        print("viewDidAppear")
        
        for landmark in landmarks {
            print("\(landmark.name) \(landmark.visited)")
        }
    }*/
    
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        let realm = try! Realm()
        
        let landmarks = realm.objects(Landmark.self)
        
        print("viewDidAppear")
        
        var visitedCount = 0
        for landmark in landmarks {
            if landmark.visited {
                visitedCount += 1
            }
            //print("\(landmark.name) \(landmark.visited)")
        }
        
        return visitedCount
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        var url:URL?
        
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        var visitedLandmarks = [Landmark]()
        
        for landmark in landmarks {
            if landmark.visited {
                visitedLandmarks.append(landmark)
            }
        }
        
        let currentLandmark = visitedLandmarks[index]
        print(currentLandmark)
        
        if let value = dict[currentLandmark.name] {
            url = Bundle.main.url(forResource: value, withExtension: "png")
        }
        
        let sticker = try! MSSticker.init(contentsOfFileURL: url!, localizedDescription: "TestThing")
        
        return sticker
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
