// HikingTabContainerView.swift
import SwiftUI

struct HikingTabContainerView: View {
    let trip: Trip
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                         NotificationCenter.default.post(name: .dismissToHome, object: trip)
                  
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}
