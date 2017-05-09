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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        
        let landmarks = realm.objects(Landmark.self)
        
        print("viewDidAppear")
        
        for landmark in landmarks {
            print("\(landmark.name) \(landmark.visited)")
        }
    }
    
    /*
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return 2
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        //let thing = Bundle.
        //let path = Bundle.main.path(forResource: "TestSticker1", ofType: "png")
        let url = Bundle.main.url(forResource: "TestSticker1", withExtension: "png")
        //let url = URL(fileURLWithPath: path!)
        //let image = UIImage(contentsOfFile: "TestSticker1")
        //let data = UIImagePNGRepresentation(image!)
        //let test = URL(dataRepresentation: data!, relativeTo: <#T##URL?#>)
        //let testUrl = URL(fileReferenceLiteralResourceName: "TestSticker1.png")
        //let testUrl = URL(fileURLWithPath: "TestSticker1.png")
        //let sticker = MSSticker(contentsOfFileURL: testUrl, localizedDescription: "Test")
        let sticker = try! MSSticker.init(contentsOfFileURL: url!, localizedDescription: "TestThing")
        
        return sticker
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
