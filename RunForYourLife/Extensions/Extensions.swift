//
//  Extensions.swift
//  RunForYourLife
//
//  Created by Valentinas Mirosnicenko on 5/13/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation

extension Double {
    
    func metersToKilometers(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return ((self / 1000) * divisor).rounded() / divisor
    }
    
}
