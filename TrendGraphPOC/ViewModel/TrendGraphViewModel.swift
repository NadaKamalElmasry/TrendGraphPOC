//
//  TrendGraphViewModel.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import Foundation
import SwiftUI


// ViewModel: Manages the state and business logic of the view
class TrendGraphViewModel: ObservableObject {
    @Published var tooltipPosition: CGPoint = .zero
    @Published var showTooltip: Bool = false
    @Published var showStripLine: Bool = false
    @Published var selectedDate: Date? = Date()
    @Published var selectedGlucose: Int? = nil
    @Published var stripLineXPosition: CGFloat? = nil
    @Published var graphHeight: Int = 300
    @Published var isLowEGV = false
    @Published var isHighEGV = false
    @Published var HightThreshold = 200
    @Published var LowThreshold = 100
    let UrgentLowThreshold = 55
    var glucoseValues = [GlucoseModel]()
    @Published var xAxisValues = [Int]()
    @Published var yAxisValues = [Int]()
    @Published var selectedTimeRange: Int = 3
    @Published var timeRange: (start: TimeInterval, end: TimeInterval) = (TimeInterval(), TimeInterval())
    
    init() {
        let (xAxisValues, timeRange) = fillXAxisValues(selectedTimeRange: 3)
        self.xAxisValues = xAxisValues
        self.timeRange = timeRange
        
        glucoseValues = [
            GlucoseModel(glucoseValue: 130, date: convertToDate(from: "07/07/2024 01:30 PM")),
            GlucoseModel(glucoseValue: 190, date: convertToDate(from: "07/07/2024 02:00 PM")),
            GlucoseModel(glucoseValue: 60, date: convertToDate(from: "07/07/2024 02:30 PM")),
            GlucoseModel(glucoseValue: 300, date: convertToDate(from: "07/07/2024 03:30 PM")),
            GlucoseModel(glucoseValue: 250, date: convertToDate(from: "07/07/2024 03:45 PM")),
            GlucoseModel(glucoseValue: 190, date: convertToDate(from: "07/07/2024 04:00 PM")),
            GlucoseModel(glucoseValue: 60, date: convertToDate(from: "07/07/2024 04:30 PM")),
            GlucoseModel(glucoseValue: 300, date: convertToDate(from: "07/07/2024 05:00 PM")),
            GlucoseModel(glucoseValue: 250, date: convertToDate(from: "07/07/2024 05:31 PM")),
        ]

    }
    
    func lineColor(for value: Int) -> Color {
        switch value {
        case UrgentLowThreshold:
            return .red
        case LowThreshold, HightThreshold:
            return .yellow
        default:
            return .clear
        }
    }
    
    func getGlucoseValueFor(date: Date) -> Int? {
        let calendar = Calendar.current
        return glucoseValues.first { glucoseData in
            if let glucoseDate = glucoseData.date {
                let glucoseHour = calendar.component(.hour, from: glucoseDate)
                let glucoseMinute = calendar.component(.minute, from: glucoseDate)
                let dateHour = calendar.component(.hour, from: date)
                let dateMinute = calendar.component(.minute, from: date)
                return glucoseHour == dateHour && glucoseMinute == dateMinute
            }
            return false
        }?.glucoseValue
    }
    
    func fillYAxisValues() -> [Int] {
        [UrgentLowThreshold, LowThreshold, HightThreshold, graphHeight]
    }
    
    func fillXAxisValues(selectedTimeRange: Int) -> (hours: [Int], timeRange: (start: TimeInterval, end: TimeInterval)) {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        var hours = [Int]()

        let interval: Int
        switch selectedTimeRange {
        case 3:
            interval = 1
        case 6:
            interval = 2
        case 12:
            interval = 4
        case 24:
            interval = 8
        default:
            interval = 1 // Fallback for unexpected values
        }
    
        hours.append(currentHour)
        for i in 1..<(selectedTimeRange / interval) {
            let hour = (currentHour - (interval * i)) % 24
            hours.append(hour < 0 ? hour + 24 : hour)
        }
            
        let endTime = now
        let startTime = calendar.date(byAdding: .hour, value: -selectedTimeRange, to: now) ?? now

        return (hours.reversed(), (start: startTime.toComparableValue(), end: endTime.toComparableValue()))
    }
    
    func convertToDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateString)
    }
}
