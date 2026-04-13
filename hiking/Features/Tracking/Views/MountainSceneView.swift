//
//  MountainSceneView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


import SwiftUI

struct MountainSceneView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .bottom) {
                // Gunung jauh kiri
                Path { path in
                    path.move(to: CGPoint(x: w * 0.05, y: h * 0.65))
                    path.addLine(to: CGPoint(x: w * 0.28, y: h * 0.28))
                    path.addLine(to: CGPoint(x: w * 0.50, y: h * 0.65))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.75, green: 0.83, blue: 0.88))

                // Gunung tengah (puncak utama)
                Path { path in
                    path.move(to: CGPoint(x: w * 0.30, y: h * 0.65))
                    path.addLine(to: CGPoint(x: w * 0.52, y: h * 0.15))
                    path.addLine(to: CGPoint(x: w * 0.74, y: h * 0.65))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.70, green: 0.79, blue: 0.85))

                // Salju puncak
                Path { path in
                    path.move(to: CGPoint(x: w * 0.52, y: h * 0.15))
                    path.addLine(to: CGPoint(x: w * 0.44, y: h * 0.32))
                    path.addLine(to: CGPoint(x: w * 0.60, y: h * 0.32))
                    path.closeSubpath()
                }
                .fill(Color.white.opacity(0.7))

                // Gunung kanan
                Path { path in
                    path.move(to: CGPoint(x: w * 0.60, y: h * 0.65))
                    path.addLine(to: CGPoint(x: w * 0.80, y: h * 0.32))
                    path.addLine(to: CGPoint(x: w, y: h * 0.65))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.78, green: 0.86, Blue: 0.90))

                // Ground / tanah
                Rectangle()
                    .fill(Color(red: 0.82, green: 0.90, blue: 0.87))
                    .frame(height: h * 0.38)

                // Garis horizon
                Rectangle()
                    .fill(Color(red: 0.70, green: 0.80, blue: 0.76))
                    .frame(height: 1.5)
                    .offset(y: -h * 0.38)

                // Rumput kecil
                ForEach(0..<12, id: \.self) { i in
                    let x = w * CGFloat(i) / 11.0
                    Path { path in
                        path.move(to: CGPoint(x: x, y: h * 0.62))
                        path.addLine(to: CGPoint(x: x - 4, y: h * 0.55))
                        path.move(to: CGPoint(x: x, y: h * 0.62))
                        path.addLine(to: CGPoint(x: x + 4, y: h * 0.55))
                    }
                    .stroke(Color(red: 0.45, green: 0.68, blue: 0.52), lineWidth: 1.5)
                }

                // Batu kecil
                Circle()
                    .fill(Color(red: 0.65, green: 0.72, blue: 0.70))
                    .frame(width: 14, height: 8)
                    .offset(x: -w * 0.25, y: -h * 0.28)

                Circle()
                    .fill(Color(red: 0.65, green: 0.72, blue: 0.70))
                    .frame(width: 10, height: 6)
                    .offset(x: w * 0.30, y: -h * 0.28)

                // Tanaman kecil kiri
                Text("🌿")
                    .font(.system(size: 16))
                    .offset(x: -w * 0.30, y: -h * 0.25)

                // Tanaman kanan
                Text("🌱")
                    .font(.system(size: 12))
                    .offset(x: w * 0.25, y: -h * 0.26)
            }
        }
    }
}

// Fix typo Blue → blue
private extension Color {
    init(red: Double, green: Double, Blue blue: Double) {
        self.init(red: red, green: green, blue: blue)
    }
}