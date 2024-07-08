//
//  View+TrendGraphView.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import Foundation
import SwiftUI

// Extension to hide view
extension View {
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
