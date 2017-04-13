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
    private let bradleyHall = Landmark(value:
        ["Bradley Hall", false, "This is Bradley Hall", 40.698312, -89.617012, NSData()])
    private let gcc = Landmark(value:
        ["Caterpillar Global Communications Center", false, "This is the GCC", 40.697943, -89.612109, NSData()])
    private let jobst = Landmark(value:
        ["Jobst Hall", false, "This is Jobst Hall", 40.699366, -89.616985, NSData()])
    private let westlake = Landmark(value:
        ["Westlake Hall", false, "This is Westlake Hall", 40.697646, -89.617006, NSData()])
    private let baker = Landmark(value:
        ["Baker Hall", false, "This is Westlake Hall", 40.699760, -89.616004, NSData()])
    private let studentCenter = Landmark(value:
        ["Michel Student Center", false, "This is the Student Center", 40.698720, -89.615148, NSData()])
    private let library = Landmark(value:
        ["Cullom-Davis Library", false, "This is the Library", 40.697093, -89.616636, NSData()])
    
    func populateRealm() {
        let database = [founders, bradleyHall, gcc, jobst, westlake, baker, studentCenter, library]
        
        let realm = try! Realm()
        
        try! realm.write {
            for landmark in database {
                realm.add(landmark)
            }
        }
    }
}
