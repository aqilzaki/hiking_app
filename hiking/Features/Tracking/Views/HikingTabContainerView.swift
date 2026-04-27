// HikingTabContainerView.swift
import SwiftUI

struct HikingTabContainerView: View {
    let trip: Trip
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
     
        VStack(spacing: 0) {
            HStack {
                Button {
                    
                        dismiss()
                    
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

                // Placeholder supaya title tetap center
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

            // Segmented Control
            Picker("", selection: $selectedTab) {
                Text("Tracking").tag(0)
                Text("Checklist").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider()

            // Content
            if selectedTab == 0 {
                HikingTrackingView(trip: trip)
            } else {
                HikingChecklistView(trip: trip)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGroupedBackground))
    }
}
