//
//  TripInfoCardView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


import SwiftUI

struct TripInfoCardView: View {
    let trip: Trip

    var body: some View {
        HStack(spacing: 0) {
            infoCell(
                icon: "mountain.2.fill",
                label: "Gunung",
                value: trip.mountainName,
                color: gradeColor(trip.grade)
            )
            divider
            infoCell(
                icon: "person.2.fill",
                label: "Pendaki",
                value: "\(trip.numberOfPeople) orang",
                color: .blue
            )
            divider
            infoCell(
                icon: "clock.fill",
                label: "Durasi",
                value: "\(trip.durationDays) hari",
                color: .orange
            )
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .frame(width: 1, height: 44)
    }

    private func infoCell(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}


