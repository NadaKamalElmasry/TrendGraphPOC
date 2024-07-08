# Trend Graph Feature Overview

This project visualizes glucose trends over a selected time range, allowing for interactive exploration of glucose data. The key features and technologies used in this project are outlined below.

## Main Implemented Features of the Trend Graph

### 1. Dynamic Glucose Value Display
- **Plots glucose values over time**: The graph dynamically plots glucose values against time to provide a visual representation of glucose trends.
- **Highlights low and high glucose zones**: Specific zones for low and high glucose values are highlighted to alert users visually.

### 2. Interactive Tooltip
- **Shows detailed glucose value and time when hovering over the graph**: An interactive tooltip displays detailed information about glucose values and their corresponding times as the user hovers over different points on the graph.

### 3. Customizable Time Range
- **Allows switching between 3, 6, 12, and 24-hour views**: Users can toggle between different time ranges to view glucose trends over various periods.

### 4. Graph Height Adjustment
- **Users can toggle the graph height between 300 and 400 units**: Provides the flexibility to adjust the graph's height based on user preference or screen size.

### 5. Threshold Indicators
- **Visual indicators for urgent low, low, and high glucose values**: The graph includes indicators for critical glucose thresholds to help users quickly identify significant glucose levels.

### 6. Drag and Drop Interaction
- **Enables dragging to view specific data points and a corresponding strip line for precise time indication**: Users can drag across the graph to view specific data points, with a strip line providing a clear indication of the precise time.

## Technologies Used

### 1. SwiftUI
- **For building the user interface and interactions**: Utilized SwiftUI to create a responsive and interactive user interface.

### 2. Swift Charts
- **RectangleMark**: Used for background and threshold highlighting.
- **PointMark**: Used to plot individual glucose data points.
- **ChartOverlay**: For enabling interactive features like tooltips and strip lines.

### 3. ObservableObject and @Published
- **For state management in the ViewModel**: Used ObservableObject and @Published properties to manage the state and update the view accordingly.

## Getting Started

To get started with the project, clone the repository and open it in Xcode. Make sure you have the latest version of Xcode and Swift installed.

```sh
git clone https://github.com/your-username/trend-graph.git
cd trend-graph
open trend-graph.xcodeproj
