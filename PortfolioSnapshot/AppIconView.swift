//
//  AppIconView.swift
//  PortfolioSnapshot
//
//  Use this view to generate app icons.
//  Run the preview, take a screenshot, and resize to 1024x1024.
//

import SwiftUI

struct AppIconView: View {
    let size: CGFloat = 1024
    
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.23, blue: 0.37),
                            Color(red: 0.18, green: 0.35, blue: 0.53),
                            Color(red: 0.12, green: 0.35, blue: 0.29)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Subtle grid pattern
            GridPattern()
                .stroke(Color.white.opacity(0.05), lineWidth: 2)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.22))
            
            // Main content
            HStack(spacing: -size * 0.08) {
                // Pie Chart
                PieChartIcon(size: size * 0.45)
                    .offset(x: -size * 0.02)
                
                // Upward Arrow
                ArrowIcon(size: size * 0.35)
                    .offset(x: -size * 0.06, y: -size * 0.02)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Pie Chart Component

struct PieChartIcon: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Green slice (40%)
            PieSlice(startAngle: -90, endAngle: 54)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.29, green: 0.87, blue: 0.50), Color(red: 0.13, green: 0.77, blue: 0.37)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Blue slice (35%)
            PieSlice(startAngle: 54, endAngle: 180)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.38, green: 0.65, blue: 0.98), Color(red: 0.23, green: 0.51, blue: 0.96)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Purple slice (25%)
            PieSlice(startAngle: 180, endAngle: 270)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.65, green: 0.55, blue: 0.98), Color(red: 0.55, green: 0.36, blue: 0.96)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Inner circle (donut hole)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.23, blue: 0.37),
                            Color(red: 0.15, green: 0.30, blue: 0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.4, height: size * 0.4)
            
            // Inner ring highlight
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 2)
                .frame(width: size * 0.38, height: size * 0.38)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Arrow Component

struct ArrowIcon: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Arrow shape
            ArrowShape()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.53, green: 0.94, blue: 0.67), Color(red: 0.13, green: 0.77, blue: 0.37)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(width: size * 0.5, height: size)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Custom Shapes

struct PieSlice: Shape {
    var startAngle: Double
    var endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(center: center, radius: radius,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Arrow pointing up
        // Shaft
        let shaftWidth = w * 0.4
        let shaftLeft = (w - shaftWidth) / 2
        let shaftRight = shaftLeft + shaftWidth
        let headHeight = h * 0.35
        let shaftTop = headHeight * 0.6
        
        // Head
        path.move(to: CGPoint(x: w / 2, y: 0)) // Top point
        path.addLine(to: CGPoint(x: w, y: headHeight)) // Right point
        path.addLine(to: CGPoint(x: shaftRight, y: headHeight)) // Inner right
        
        // Shaft right side
        path.addLine(to: CGPoint(x: shaftRight, y: h - shaftWidth / 2))
        
        // Rounded bottom
        path.addArc(center: CGPoint(x: w / 2, y: h - shaftWidth / 2),
                    radius: shaftWidth / 2,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: false)
        
        // Shaft left side
        path.addLine(to: CGPoint(x: shaftLeft, y: headHeight))
        
        // Back to head
        path.addLine(to: CGPoint(x: 0, y: headHeight)) // Left point
        path.closeSubpath()
        
        return path
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing = rect.width / 5
        
        for i in 1..<5 {
            let x = spacing * CGFloat(i)
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            
            let y = spacing * CGFloat(i)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

// MARK: - Previews

#Preview("App Icon - 1024pt") {
    AppIconView()
        .frame(width: 1024, height: 1024)
}

#Preview("App Icon - Small") {
    AppIconView()
        .frame(width: 200, height: 200)
}

#Preview("App Icon - Home Screen Size") {
    AppIconView()
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 13))
}

