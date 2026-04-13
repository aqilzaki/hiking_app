//
//  HikingLiveActivityWidget.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Live Activity Widget
struct HikingLiveActivityWidget: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HikingActivityAttributes.self) { context in
            // Lock Screen / Banner
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.phase.sfSymbol)
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(context.state.phase.rawValue)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.7))
                            Text(context.attributes.tripId.prefix(8) == context.attributes.tripId.prefix(8) ? context.state.mountainName : "")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(context.state.elapsedFormatted)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text(context.state.remainingFormatted)
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.trailing, 4)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        
                        // MARK: Mountain silhouette + hiker path
                        ZStack(alignment: .leading) {
                            
                            // Mountain silhouette background
                            MountainSilhouetteShape()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            gradeActivityColor(context.attributes.grade).opacity(0.15),
                                            gradeActivityColor(context.attributes.grade).opacity(0.05)
                                        ],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .frame(height: 44)
                            
                            // Dashed path line
                            GeometryReader { geo in
                                // Dashed trail line
                                Path { path in
                                    let width = geo.size.width
                                    let height = geo.size.height
                                    path.move(to: CGPoint(x: 8, y: height - 8))
                                    path.addCurve(
                                        to: CGPoint(x: width - 8, y: height - 8),
                                        control1: CGPoint(x: width * 0.35, y: height * 0.1),
                                        control2: CGPoint(x: width * 0.65, y: height * 0.1)
                                    )
                                }
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 1.5,
                                        dash: [4, 3]
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.3))
                                
                                // Progress filled path
                                Path { path in
                                    let width = geo.size.width
                                    let height = geo.size.height
                                    path.move(to: CGPoint(x: 8, y: height - 8))
                                    path.addCurve(
                                        to: CGPoint(x: width - 8, y: height - 8),
                                        control1: CGPoint(x: width * 0.35, y: height * 0.1),
                                        control2: CGPoint(x: width * 0.65, y: height * 0.1)
                                    )
                                }
                                .trim(from: 0, to: context.state.progress)
                                .stroke(
                                    gradeActivityColor(context.attributes.grade),
                                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                )
                                
                                // Day markers di sepanjang path
                                let days = context.attributes.totalDays
                                ForEach(0...days, id: \.self) { day in
                                    let t = days > 0 ? Double(day) / Double(days) : 0
                                    let point = pointOnCurve(t: t, in: geo.size)
                                    let isPassed = Double(day) / Double(days) <= context.state.progress
                                    
                                    ZStack {
                                        Circle()
                                            .fill(isPassed
                                                  ? gradeActivityColor(context.attributes.grade)
                                                  : Color.white.opacity(0.2))
                                            .frame(width: 8, height: 8)
                                        if day == 0 || day == days {
                                            Circle()
                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    .position(point)
                                    
                                    // Label hari
                                    if day == 0 {
                                        Text("Start")
                                            .font(.system(size: 7, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.5))
                                            .position(x: point.x, y: point.y + 10)
                                    } else if day == days {
                                        Text("Puncak")
                                            .font(.system(size: 7, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.5))
                                            .position(x: point.x, y: point.y - 12)
                                    } else {
                                        Text("H+\(day)")
                                            .font(.system(size: 7))
                                            .foregroundStyle(.white.opacity(0.4))
                                            .position(x: point.x, y: point.y + 11)
                                    }
                                }
                                
                                // Hiker emoji di posisi progress saat ini
                                let hikerPoint = pointOnCurve(t: context.state.progress, in: geo.size)
                                Text(context.state.phase.emoji)
                                    .font(.system(size: 14))
                                    .position(x: hikerPoint.x, y: hikerPoint.y - 12)
                                    .shadow(color: gradeActivityColor(context.attributes.grade).opacity(0.8), radius: 4)
                            }
                            .frame(height: 44)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 8)
                        
                        // MARK: Info bawah
                        HStack {
                            Label(context.state.elapsedFormatted, systemImage: "clock")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.5))
                            Spacer()
                            Text(context.state.phase.rawValue)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(gradeActivityColor(context.attributes.grade).opacity(0.8))
                            Spacer()
                            Label(context.state.remainingFormatted, systemImage: "flag")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 4)
                    }
                }
            } compactLeading: {
                // Compact leading — ikon fase
                Image(systemName: context.state.phase.sfSymbol)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(gradeActivityColor(context.attributes.grade))

            } compactTrailing: {
                // Compact trailing — progress %
                Text("\(Int(context.state.progress * 100))%")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

            } minimal: {
                // Minimal — emoji saja
                Text(context.state.phase.emoji)
                    .font(.system(size: 12))
            }
            .keylineTint(gradeActivityColor(context.attributes.grade))
        }
    }
}
