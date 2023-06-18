//
//  TimeInterval+extension.swift
//  EntainHomeTask
//
//  Created by Yin Hua on 17/6/2023.
//

import Foundation

extension TimeInterval {
    
    // If it returns true, display this summary
    func isLessThanOneMinutePassed() -> Bool {
        let now = Date().timeIntervalSince1970
        return (self - now) > -60
    }
    
    func isOneMinutePassed() -> Bool {
        return self <= -60
    }

    func getDuration() -> TimeInterval {
        let now = Date().timeIntervalSince1970
        return self - now
    }

    func formattedDuration() -> String {
        let difference = self
        let totalSeconds = Int(abs(difference))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        let sign = difference < 0 ? "-" : ""
        
        var formattedString = sign
        
        if hours > 0 {
            formattedString += "\(hours)h "
        }
        
        if minutes > 0 {
            formattedString += "\(minutes)m "
        }
        
        formattedString += "\(seconds)s"
        
        return formattedString
    }

}
