//
//  StripLineView.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 07/07/2024.
//

import SwiftUI

struct StripLineView: View {
    var position: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: self.position, y: 0))
                path.addLine(to: CGPoint(x: self.position, y: geometry.size.height))
            }
            .stroke(Color.black.opacity(0.2), lineWidth: 2)
        }
    }
}

#Preview {
    StripLineView(position: CGFloat(100))
}
