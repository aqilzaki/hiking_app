//
//  HikingTrackingView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


//  HikingTrackingView.swift
//  hiking

import SwiftUI

struct HikingTrackingView: View {
    let trip: Trip
    @State private var animateHiker = false
    @State private var hikerOffset: CGFloat = -60
    @Environment(\.dismiss) private var dismiss

    // Progress simulasi berdasarkan waktu
    @State private var currentDay: Int = 1

    var totalDays: Int { trip.durationDays }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Ilustrasi Hiker
                ZStack(alignment: .bottom) {
                    // Background langit
                    LinearGradient(
                        colors: [Color(red: 0.85, green: 0.92, blue: 0.95),
                                 Color(red: 0.95, green: 0.97, blue: 0.98)],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    // Gunung background (siluet)
                    MountainSceneView()
                        .frame(height: 320)

                    // Jalur putus-putus dengan pin
                    TrailPathView(
                        totalDays: totalDays,
                        currentDay: currentDay,
                        gradeColor: gradeColor(trip.grade)
                    )
                    .frame(height: 200)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60)

                    // Hiker illustration
                    HikerView(isAnimating: animateHiker)
                        .frame(width: 140, height: 180)
                        .offset(x: hikerOffset, y: 0)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: hikerOffset
                        )
                }
                .frame(height: 320)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // MARK: - Day Progress
                VStack(spacing: 12) {
                    DayProgressView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        gradeColor: gradeColor(trip.grade)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                    // MARK: - Notifikasi Card
                    NotificationCardView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        mountainName: trip.mountainName
                    )
                    .padding(.horizontal, 16)

                    // MARK: - Trip Info
                    TripInfoCardView(trip: trip)
                        .padding(.horizontal, 16)

                    // MARK: - Selesai Button
                    if currentDay >= totalDays {
                        Button {
                            LiveActivityManager.shared.stop()
                            dismiss()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Selesai Mendaki! 🎉")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(trip.mountainName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            animateHiker = true
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                hikerOffset = 60
            }
        }
    }
}

// MARK: - Mountain Scene
struct MountainSceneView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .bottom) {
                // Gunung jauh (abu)
                Path { path in
                    path.move(to: CGPoint(x: w * 0.55, y: h * 0.35))
                    path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.65))
                    path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.65))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.82, green: 0.87, blue: 0.90))

                // Gunung kanan
                Path { path in
                    path.move(to: CGPoint(x: w * 0.78, y: h * 0.28))
                    path.addLine(to: CGPoint(x: w * 0.95, y: h * 0.6))
                    path.addLine(to: CGPoint(x: w * 0.6, y: h * 0.6))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.78, green: 0.84, blue: 0.88))

                // Tanah / ground
                Rectangle()
                    .fill(Color(red: 0.88, green: 0.92, blue: 0.90))
                    .frame(height: h * 0.35)
                    .frame(maxWidth: .infinity)

                // Rumput kecil
                Path { path in
                    for i in stride(from: 0, to: Int(w), by: 40) {
                        let x = CGFloat(i)
                        let y = h * 0.65
                        path.move(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x - 5, y: y - 12))
                        path.move(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x + 5, y: y - 12))
                    }
                }
                .stroke(Color(red: 0.55, green: 0.75, blue: 0.55), lineWidth: 1.5)
            }
        }
    }
}

// MARK: - Hiker View (SVG-style pakai SwiftUI shapes)
struct HikerView: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            // Bayangan
            Ellipse()
                .fill(Color.black.opacity(0.06))
                .frame(width: 60, height: 12)
                .offset(y: 62)

            // Tas ransel
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.25, green: 0.35, blue: 0.50))
                    .frame(width: 38, height: 46)
                    .offset(x: -8, y: -10)

                // Tali tas
                Capsule()
                    .fill(Color(red: 0.3, green: 0.4, blue: 0.55))
                    .frame(width: 6, height: 30)
                    .offset(x: 2, y: -2)
            }

            // Badan
            Capsule()
                .fill(Color(red: 0.85, green: 0.30, blue: 0.25))
                .frame(width: 34, height: 50)
                .offset(y: -10)

            // Kepala
            Circle()
                .fill(Color(red: 0.90, green: 0.72, blue: 0.58))
                .frame(width: 32, height: 32)
                .offset(y: -42)

            // Topi/rambut
            Capsule()
                .fill(Color(red: 0.65, green: 0.22, blue: 0.18))
                .frame(width: 34, height: 16)
                .offset(y: -52)

            // Celana
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(red: 0.20, green: 0.25, blue: 0.35))
                .frame(width: 30, height: 30)
                .offset(y: 18)

            // Kaki kiri (animasi jalan)
            Capsule()
                .fill(Color(red: 0.20, green: 0.25, blue: 0.35))
                .frame(width: 10, height: 28)
                .offset(x: -8, y: 42)
                .rotationEffect(.degrees(isAnimating ? -15 : 15), anchor: .top)

            // Kaki kanan
            Capsule()
                .fill(Color(red: 0.20, green: 0.25, blue: 0.35))
                .frame(width: 10, height: 28)
                .offset(x: 8, y: 42)
                .rotationEffect(.degrees(isAnimating ? 15 : -15), anchor: .top)

            // Sepatu kiri
            Capsule()
                .fill(Color(red: 0.80, green: 0.25, blue: 0.20))
                .frame(width: 16, height: 8)
                .offset(x: -10, y: 58)

            // Sepatu kanan
            Capsule()
                .fill(Color(red: 0.80, green: 0.25, blue: 0.20))
                .frame(width: 16, height: 8)
                .offset(x: 6, y: 58)

            // Tangan kiri
            Capsule()
                .fill(Color(red: 0.85, green: 0.30, blue: 0.25))
                .frame(width: 8, height: 22)
                .offset(x: -20, y: 5)
                .rotationEffect(.degrees(isAnimating ? 20 : -20), anchor: .top)

            // Tangan kanan
            Capsule()
                .fill(Color(red: 0.85, green: 0.30, blue: 0.25))
                .frame(width: 8, height: 22)
                .offset(x: 20, y: 5)
                .rotationEffect(.degrees(isAnimating ? -20 : 20), anchor: .top)
        }
    }
}

// MARK: - Trail Path dengan Pin
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
                    path.move(to: CGPoint(x: 20, y: h * 0.7))
                    for i in 1...max(1, totalDays) {
                        let t = Double(i) / Double(totalDays)
                        let x = 20 + (w - 40) * t
                        let y = h * 0.7 - sin(t * .pi) * h * 0.5
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(
                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                )
                .foregroundStyle(Color(red: 0.4, green: 0.55, blue: 0.65).opacity(0.5))

                // Garis progress (sudah dilalui)
                Path { path in
                    path.move(to: CGPoint(x: 20, y: h * 0.7))
                    for i in 1...max(1, min(currentDay, totalDays)) {
                        let t = Double(i) / Double(totalDays)
                        let x = 20 + (w - 40) * t
                        let y = h * 0.7 - sin(t * .pi) * h * 0.5
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(gradeColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))

                // Pin & label per hari
                ForEach(0...totalDays, id: \.self) { day in
                    let t = totalDays > 0 ? Double(day) / Double(totalDays) : 0
                    let x = 20 + (w - 40) * t
                    let y = h * 0.7 - sin(t * .pi) * h * 0.5
                    let isPassed = day <= currentDay

                    // Pin
                    ZStack {
                        // Pin shape
                        Circle()
                            .fill(isPassed ? gradeColor : Color(red: 0.75, green: 0.80, blue: 0.85))
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 3, y: 2)

                        // Stem pin
                        Triangle()
                            .fill(isPassed ? gradeColor : Color(red: 0.75, green: 0.80, blue: 0.85))
                            .frame(width: 6, height: 6)
                            .offset(y: 9)
                    }
                    .position(x: x, y: y - 10)

                    // Label hari
                    Text(day == 0 ? "Start" : day == totalDays ? "Puncak" : "\(day) days")
                        .font(.system(size: 10, weight: day == 0 || day == totalDays ? .bold : .regular))
                        .foregroundStyle(isPassed ? gradeColor : Color(red: 0.5, green: 0.55, blue: 0.6))
                        .position(x: x, y: y + 18)
                }
            }
        }
    }
}

// MARK: - Triangle shape untuk pin
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Day Progress Bar
struct DayProgressView: View {
    let currentDay: Int
    let totalDays: Int
    let gradeColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(currentDay) days")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                // Dashes
                HStack(spacing: 4) {
                    ForEach(0..<totalDays, id: \.self) { i in
                        Capsule()
                            .fill(i < currentDay ? gradeColor : Color(.systemGray4))
                            .frame(width: 20, height: 3)
                    }
                }

                Spacer()

                Text("\(totalDays) days")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Notification Card
struct NotificationCardView: View {
    let currentDay: Int
    let totalDays: Int
    let mountainName: String

    var notifMessage: String {
        switch currentDay {
        case 1:
            return "Hei jangan lupa untuk cek\nbarang bawaan saat pulang ya"
        case totalDays:
            return "Kamu sudah di puncak! Selamat 🎉\nJaga keselamatan saat turun"
        default:
            return "Hari ke-\(currentDay) mendaki \(mountainName)\nSemangat terus! 💪"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notifikasi")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.primary)

            Text(notifMessage)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Trip Info Card
struct TripInfoCardView: View {
    let trip: Trip

    var body: some View {
        HStack(spacing: 0) {
            infoCell(icon: "mountain.2.fill", label: "Gunung", value: trip.mountainName, color: gradeColor(trip.grade))
            Divider().frame(height: 40)
            infoCell(icon: "person.2.fill", label: "Pendaki", value: "\(trip.numberOfPeople) orang", color: .blue)
            Divider().frame(height: 40)
            infoCell(icon: "clock.fill", label: "Durasi", value: "\(trip.durationDays) hari", color: .orange)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func infoCell(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}