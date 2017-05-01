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
    
    private let lydia = UIImage(named: "Lydia")
    private let bHall = UIImage(named: "BradleyHall")
    private let catGCC = UIImage(named: "GCC")
    private let jobstHall = UIImage(named: "JobstHall")
    private let westLakeHall = UIImage(named: "WestlakeHall")
    private let bakerHall = UIImage(named: "BakerHall")
    private let sC = UIImage(named: "StudentCenter")
    private let lib = UIImage(named: "Library")
    
    private let founders = Landmark(value:
        ["Founder's Circle", false, "This is Founder's Circle", 40.698143, -89.616412, NSData()])
    private let bradleyHall = Landmark(value:
        ["Bradley Hall", false, "Bradley Hall, one of the University's original buildings, is one of the main academic buildings on campus. It houses the main offices for the College of Liberal Arts and Sciences. It also houses faculty offices and lab space for the College of Education and Health Sciences", 40.698312, -89.617012, NSData()])
    private let gcc = Landmark(value:
        ["Caterpillar GCC", false, "The Caterpillar Global Communications Center is home to the Slane College of Communications and Fine Arts. In addition to computer labs and classrooms, the building features a HD television production studio, editing rooms and a state-of-the-art conference room.", 40.697943, -89.612109, NSData()])
    private let jobst = Landmark(value:
        ["Jobst Hall", false, "Jobst Hall is home to Bradley's Caterpillar College of Engineering and Technology and Peoria NPR affiliate WCBU. It has classrooms, computer labs, workshops and faculty offices.", 40.699366, -89.616985, NSData()])
    private let westlake = Landmark(value:
        ["Westlake Hall", false, "Westlake Hall is home to the College of Education and Health Sciences and the Institute for Principled Leadership in Public Service. It has state-of-the-art classrooms and creative study spaces for students.", 40.697646, -89.617006, NSData()])
    private let baker = Landmark(value:
        ["Baker Hall", false, "Baker Hall is the campus hub for business students and faculty. It is home to the Foster College of Business, in addition to the College's research, professional development and economic development centers.", 40.699760, -89.616004, NSData()])
    private let studentCenter = Landmark(value:
        ["Michel Student Center", false, "The Michel Student Center, at the heart of campus, features a food court, 500-seat ballroom and spaces to meet or study.", 40.698720, -89.615148, NSData()])
    private let library = Landmark(value:
        ["Cullom-Davis Library", false, "Cullom-Davis Library features an extensive collection of publications, a computer lab and online access to publications. The library also has a coffee shop — The Stacks — and a variety of spaces for study or meetings.", 40.697093, -89.616636, NSData()])
    
    func populateRealm() {
        founders.image = NSData(data: UIImagePNGRepresentation(lydia!)!)
        bradleyHall.image = NSData(data: UIImagePNGRepresentation(bHall!)!)
        gcc.image = NSData(data: UIImagePNGRepresentation(catGCC!)!)
        jobst.image = NSData(data: UIImagePNGRepresentation(jobstHall!)!)
        westlake.image = NSData(data: UIImagePNGRepresentation(westLakeHall!)!)
        baker.image = NSData(data: UIImagePNGRepresentation(bakerHall!)!)
        studentCenter.image = NSData(data: UIImagePNGRepresentation(sC!)!)
        library.image = NSData(data: UIImagePNGRepresentation(lib!)!)
        
        let database = [founders, bradleyHall, gcc, jobst, westlake, baker, studentCenter, library]
        
        let realm = try! Realm()
        
        try! realm.write {
            for landmark in database {
                realm.add(landmark)
            }
        }
    }
}
