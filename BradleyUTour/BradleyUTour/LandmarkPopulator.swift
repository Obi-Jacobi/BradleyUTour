//
//  LandmarkPopulator.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/13/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import Foundation
import RealmSwift

struct LandmarkPopulator {
    
    private let founders = Landmark(value:
        ["Founder's Circle", false, "This is Founder's Circle", 40.698143, -89.616412, NSData()])
        
    
    func populateRealm() {
        let database = [founders]
        
        for landmark in database {
            print(landmark)
        }
    }
}
