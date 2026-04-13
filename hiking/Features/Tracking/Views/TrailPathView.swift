//
//  TrailPathView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


import SwiftUI

struct TrailPathView: View {
    let totalDays: Int
    let currentDay: Int
    let gradeColor: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Garis putus-putus full path
                Path { path in
                    path.move(to: CGPoint(x: 16, y: h * 0.85))
                    path.addCurve(
                        to: CGPoint(x: w - 16, y: h * 0.85),
                        control1: CGPoint(x: w * 0.30, y: -h * 0.2),
                        control2: CGPoint(x: w * 0.70, y: -h * 0.2)
                    )
                }
                .stroke(
                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                )
                .foregroundStyle(Color(red: 0.35, green: 0.50, blue: 0.60).opacity(0.5))

                // Garis progress yang sudah dilalui
                let progressRatio = totalDays > 0
                    ? min(1.0, Double(currentDay) / Double(totalDays))
                    : 0

                Path { path in
                    path.move(to: CGPoint(x: 16, y: h * 0.85))
                    path.addCurve(
                        to: CGPoint(x: w - 16, y: h * 0.85),
                        control1: CGPoint(x: w * 0.30, y: -h * 0.2),
                        control2: CGPoint(x: w * 0.70, y: -h * 0.2)
                    )
                }
                .trim(from: 0, to: progressRatio)
                .stroke(
                    gradeColor,
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )

                // Pin lokasi per hari
                ForEach(0...max(1, totalDays), id: \.self) { day in
                    let t = totalDays > 0 ? Double(day) / Double(totalDays) : 0
                    let pt = bezierPoint(t: t, w: w, h: h)
                    let isPassed = day <= currentDay

                    // Pin
                    ZStack {
                        Circle()
                            .fill(isPassed ? gradeColor : Color(red: 0.70, green: 0.78, blue: 0.84))
                            .frame(width: 16, height: 16)
                            .shadow(color: .black.opacity(0.15), radius: 3, y: 2)

                        if day == 0 || day == totalDays {
                            // Pin besar untuk start & puncak
                            PinShape()
                                .fill(isPassed ? gradeColor : Color(red: 0.60, green: 0.70, blue: 0.78))
                                .frame(width: 20, height: 26)
                                .offset(y: -4)
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 3)

                            Image(systemName: day == 0 ? "figure.stand" : "mountain.2.fill")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .offset(y: -7)
                        } else {
                            Circle()
                                .fill(isPassed ? gradeColor : Color(red: 0.70, green: 0.78, blue: 0.84))
                                .frame(width: 10, height: 10)
                                .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                        }
                    }
                    .position(pt)

                    // Label
                    Text(day == 0 ? "Start" : day == totalDays ? "Puncak" : "\(day) days")
                        .font(.system(size: day == 0 || day == totalDays ? 11 : 10,
                                      weight: day == 0 || day == totalDays ? .bold : .regular))
                        .foregroundStyle(isPassed ? gradeColor : Color(red: 0.45, green: 0.55, blue: 0.62))
                        .position(x: pt.x, y: pt.y + (day == totalDays ? -22 : 16))
                }
            }
        }
    }

    private func bezierPoint(t: Double, w: CGFloat, h: CGFloat) -> CGPoint {
        let p0 = CGPoint(x: 16,     y: h * 0.85)
        let p1 = CGPoint(x: w * 0.30, y: -h * 0.2)
        let p2 = CGPoint(x: w * 0.70, y: -h * 0.2)
        let p3 = CGPoint(x: w - 16, y: h * 0.85)
        let mt = 1 - t
        return CGPoint(
            x: mt*mt*mt*p0.x + 3*mt*mt*t*p1.x + 3*mt*t*t*p2.x + t*t*t*p3.x,
            y: mt*mt*mt*p0.y + 3*mt*mt*t*p1.y + 3*mt*t*t*p2.y + t*t*t*p3.y
        )
    }
}

// MARK: - Pin Shape (teardrop)
struct PinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let r  = rect.width / 2
        path.addArc(
            center: CGPoint(x: cx, y: r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: cx, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}