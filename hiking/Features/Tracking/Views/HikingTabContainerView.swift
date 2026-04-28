// HikingTabContainerView.swift
import SwiftUI

struct HikingTabContainerView: View {
    let trip: Trip
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar manual
            HStack {
                Button {
                    NotificationCenter.default.post(name: .dismissToHome, object: nil)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Beranda")
                    }
                    .foregroundStyle(.primary)
                }

                Spacer()

                Text(trip.mountainName)
                    .font(.headline)

                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Beranda")
                }
                .foregroundStyle(.clear)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))

            Divider()

            Picker("", selection: $selectedTab) {
                Text("Tracking").tag(0)
                Text("Checklist").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider()

            if selectedTab == 0 {
                HikingTrackingView(trip: trip)
            } else {
                HikingChecklistView(trip: trip)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
