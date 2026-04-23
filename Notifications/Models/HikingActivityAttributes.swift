//
//  HikingActivityAttributes.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


//  HikingLiveActivity.swift
//  HikingLiveActivity (Widget Extension Target)

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Attributes
struct HikingActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var mountainName: String
        var elapsedMinutes: Int
        var estimatedTotalMinutes: Int
        var phase: HikingPhase
        var numberOfPeople: Int
        

        var progress: Double {
            guard estimatedTotalMinutes > 0 else { return 0 }
            return min(1.0, Double(elapsedMinutes) / Double(estimatedTotalMinutes))
        }

        var elapsedFormatted: String {
            let h = elapsedMinutes / 60
            let m = elapsedMinutes % 60
            if h > 0 { return "\(h)j \(m)m" }
            return "\(m) menit"
        }

        var remainingFormatted: String {
            let remaining = max(0, estimatedTotalMinutes - elapsedMinutes)
            let h = remaining / 60
            let m = remaining % 60
            if h > 0 { return "\(h)j \(m)m lagi" }
            return "\(m) menit lagi"
        }
    }

    var tripId: String
    var grade: Int
    var totalDays: Int
}

enum HikingPhase: String, Codable, Hashable {
    case preparing  = "Persiapan"
    case hiking     = "Mendaki"
    case summit     = "Puncak!"
    case descending = "Turun"
    case done       = "Selesai"

    var emoji: String {
        switch self {
        case .preparing:  return "🎒"
        case .hiking:     return "🥾"
        case .summit:     return "🏔️"
        case .descending: return "⬇️"
        case .done:       return "✅"
        }
    }

    var sfSymbol: String {
        switch self {
        case .preparing:  return "bag.fill"
        case .hiking:     return "figure.hiking"
        case .summit:     return "mountain.2.fill"
        case .descending: return "arrow.down.circle.fill"
        case .done:       return "checkmark.seal.fill"
        }
    }
}





// MARK: - Color Helper (tidak bisa pakai func dari main app)
func gradeActivityColor(_ grade: Int) -> Color {
    switch grade {
    case 1: return .green
    case 2: return .blue
    case 3: return .orange
    case 4: return .red
    case 5: return .purple
    default: return .blue
    }
}

// MARK: - Bezier curve point helper
func pointOnCurve(t: Double, in size: CGSize) -> CGPoint {
    let w = size.width
    let h = size.height
    let p0 = CGPoint(x: 8, y: h - 8)
    let p1 = CGPoint(x: w * 0.35, y: h * 0.1)
    let p2 = CGPoint(x: w * 0.65, y: h * 0.1)
    let p3 = CGPoint(x: w - 8, y: h - 8)

    let mt = 1 - t
    let x = mt*mt*mt*p0.x + 3*mt*mt*t*p1.x + 3*mt*t*t*p2.x + t*t*t*p3.x
    let y = mt*mt*mt*p0.y + 3*mt*mt*t*p1.y + 3*mt*t*t*p2.y + t*t*t*p3.y
    return CGPoint(x: x, y: y)
}

// MARK: - Mountain Silhouette Shape
struct MountainSilhouetteShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: w * 0.2, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.1))  // puncak
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.4))
        path.addLine(to: CGPoint(x: w, y: h * 0.6))
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}
