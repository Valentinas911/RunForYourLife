//
//  LogCell.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var averagePace: UILabel!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(run: Run) {
        averagePace.text = "\(run.pace.formatTimeDurationToString()) min"
        dateCell.text = run.date.getDateString()
        durationLabel.text = "\(run.duration.formatTimeDurationToString())"
        distanceCell.text = "\(run.distance.metersToKilometers(places: 2)) km"
    }

}
