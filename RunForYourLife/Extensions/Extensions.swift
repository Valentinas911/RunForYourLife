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

extension Int {
    
    func formatTimeDurationToString() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self & 3600) / 60
        let durationSeconds = (self % 3600) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d:", durationHours,durationMinutes,durationSeconds)
            }
        }
    }
    
    
}
