//
//  TrendGraphToolTipView.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import SwiftUI

// Tooltip view
struct TrendGraphToolTipView: View {
    @Binding var date: Date?
    @Binding var glucose: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let date = date {
                Text(timeString(fromDate: date))
                    .font(.caption)
                    .foregroundColor(.white)
            }
            Text(glucoseInfoText(fromGlucose: glucose))
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
    
    func timeString(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a" // Update format to exclude the year
        return dateFormatter.string(from: date)
    }
    
    func glucoseInfoText(fromGlucose glucose: Int?) -> String {
        guard let glucose = glucose else {
            return "---" // Display 0 if glucose value is nil
        }
        return "\(glucose) mg/dL"
    }
}


#Preview {
    TrendGraphToolTipView(date: .constant(Date().addingTimeInterval(15400)), glucose: .constant(120))
}
