//
//  TrendGraphView.swift
//  TrendGraphPOC
//
//  Created by Nada Elmasry on 02/07/2024.
//

import SwiftUI
import Charts

struct TrendGraphView: View {
    @StateObject private var viewModel = TrendGraphViewModel()

    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Chart {
                        // Background rectangles
                        RectangleMark(xStart: .value("", viewModel.timeRange.start), xEnd: .value("", viewModel.timeRange.end), yStart: .value("", 0), yEnd: .value("", viewModel.graphHeight + 10))
                            .foregroundStyle(Color.gray.opacity(0.1))
                        
                        if viewModel.isLowEGV {
                            RectangleMark(xStart: .value("", viewModel.timeRange.start), xEnd: .value("", viewModel.timeRange.end), yStart: .value("", viewModel.UrgentLowThreshold), yEnd: .value("", viewModel.LowThreshold))
                                .foregroundStyle(Color.yellow.opacity(0.8))
                        }
                        
                        if viewModel.isHighEGV {
                            RectangleMark(xStart: .value("", viewModel.timeRange.start), xEnd: .value("", viewModel.timeRange.end), yStart: .value("", viewModel.HightThreshold), yEnd: .value("", viewModel.graphHeight))
                                .foregroundStyle(Color.yellow.opacity(0.8))
                        }
                        
                        // Points on the chart
                        ForEach(viewModel.glucoseValues) { value in
                            PointMark(
                                x: .value("Time", value.date?.toComparableValue() ?? 0),
                                y: .value("Glucose Value", value.glucoseValue)
                            )
                            .foregroundStyle(Color.black)
                        }
                    }
                    .frame(height: CGFloat(viewModel.graphHeight))
                    .coordinateSpace(name: "chartSpace") // Define the custom coordinate space
                    .chartXScale(domain: viewModel.timeRange.start...viewModel.timeRange.end)
                    .chartXAxis {
                        AxisMarks() { value in
                            AxisTick()
                                .foregroundStyle(.black)
                            AxisValueLabel {
                                if let val = value.as(TimeInterval.self) {
                                    Text(Date(timeIntervalSinceReferenceDate: val).toTimeString())
                                }
                            }
                            .foregroundStyle(.black)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: viewModel.fillYAxisValues()) { value in
                            AxisGridLine()
                                .foregroundStyle(viewModel.lineColor(for: value.as(Int.self) ?? 0))
                            AxisTick()
                                .foregroundStyle(.black)
                            AxisValueLabel()
                                .foregroundStyle(.black)
                        }
                    }
                    
                    .chartOverlay { (chartProxy: ChartProxy) in
                        Group {
                            if let position = viewModel.stripLineXPosition, viewModel.showStripLine {
                                StripLineView(position: position)
                            }
                        }
                        
                        Color.clear
                            .contentShape(Rectangle()) // Enable hit testing on the clear background
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { gesture in
                                        let location = gesture.location
                                        viewModel.showTooltip = true
                                        viewModel.showStripLine = true
                                        
                                        // Calculate the position in the chart's coordinate space
                                        if let date = chartProxy.value(atX: location.x, as: Date.self) {
                                            viewModel.selectedDate = date
                                            viewModel.selectedGlucose = viewModel.getGlucoseValueFor(date: date)
                                            viewModel.stripLineXPosition = location.x // Set initial position on click
                                            
                                            // Update tooltip position relative to chart
                                            let chartFrame = geometry.frame(in: .local)
                                            viewModel.tooltipPosition = CGPoint(x: location.x, y: chartFrame.minY - 15) // Adjust the Y position as needed
                                        }
                                    }
                                    .onEnded { _ in
                                        viewModel.showTooltip = false
                                        viewModel.showStripLine = false
                                        viewModel.selectedDate = nil
                                    }
                            )
                    }
                    .padding()
                }
                
                // Tooltip view
                if viewModel.showTooltip, let position = viewModel.stripLineXPosition {
                    TrendGraphToolTipView(date: $viewModel.selectedDate, glucose: $viewModel.selectedGlucose)
                        .position(x: position, y: viewModel.tooltipPosition.y)
                        .isHidden(!viewModel.showTooltip && viewModel.stripLineXPosition != nil)
                }
            }
            
            // Buttons under the chart
            HStack {
                Button(action: {
                    viewModel.graphHeight = 300
                }) {
                    Text("Height = 300")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.graphHeight = 400
                }) {
                    Text("Height = 400")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 10)
            
            HStack {
                Button(action: {
                    viewModel.isHighEGV.toggle()
                }) {
                    Text("\(viewModel.isHighEGV ? "Normal EGV" : "High EGV")")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.isLowEGV.toggle()
                }) {
                    Text("\(viewModel.isLowEGV ? "Normal EGV" : "Low EGV")")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 10)
            
            HStack {
                Button(action: {
                    viewModel.selectedTimeRange = 3
                    (viewModel.xAxisValues, viewModel.timeRange)  = viewModel.fillXAxisValues(selectedTimeRange: 3)
                    print("3H: \(viewModel.xAxisValues)")
                }) {
                    Text("3 Hours")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.selectedTimeRange = 6
                    (viewModel.xAxisValues, viewModel.timeRange)  = viewModel.fillXAxisValues(selectedTimeRange: 6)
                    print("6H: \(viewModel.xAxisValues)")
                }) {
                    Text("6 Hours")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.selectedTimeRange = 12
                    (viewModel.xAxisValues, viewModel.timeRange)  = viewModel.fillXAxisValues(selectedTimeRange: 12)
                    print("12H: \(viewModel.xAxisValues)")
                }) {
                    Text("12 Hours")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.selectedTimeRange = 24
                    (viewModel.xAxisValues, viewModel.timeRange)  = viewModel.fillXAxisValues(selectedTimeRange: 24)
                    print("24H: \(viewModel.xAxisValues)")
                }) {
                    Text("24 Hours")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.primary.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 40)
        }
        .padding(.top, 50)
    }
}

struct TrendGraphView_Previews: PreviewProvider {
    static var previews: some View {
        TrendGraphView()
    }
}
