//
//  Date+TrendGraphView.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import Foundation

extension Date {
    func toComparableValue() -> TimeInterval {
        print("DataPointTime\(self.toTimeString())")
        print("DataPointXAxisValue: \(self.timeIntervalSinceReferenceDate)")
        return self.timeIntervalSinceReferenceDate
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}