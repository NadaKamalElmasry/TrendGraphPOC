//
//  GlucoseModel.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import Foundation

struct GlucoseModel: Identifiable {
    var id = UUID()
    var glucoseValue: Int
    var date: Date?
}
