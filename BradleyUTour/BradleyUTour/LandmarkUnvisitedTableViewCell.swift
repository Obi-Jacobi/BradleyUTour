//
//  LandmarkTableViewCell.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/13/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit

class LandmarkUnvisitedTableViewCell: UITableViewCell {

    @IBOutlet var landmarkName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
