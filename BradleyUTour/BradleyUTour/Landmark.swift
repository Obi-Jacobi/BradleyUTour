//
//  File.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 5/8/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import Foundation
import RealmSwift

class Landmark: Object {
    dynamic var name = ""
    dynamic var visited = false
    dynamic var landmarkDescription = ""
    dynamic var latitude:Double = 0.0
    dynamic var longitude:Double = 0.0
    dynamic var image = NSData()
}
