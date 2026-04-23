//  hikingApp.swift

import SwiftUI

@main
struct hikingApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

// MARK: - Root View (handle resume trip aktif)
struct RootView: View {
    @State private var activePackingTrip: Trip? = TripStorage.shared.loadActiveTrip()
    @State private var activeJourneyTrip: Trip? = HikingJourneyStorage.shared.loadActiveJourneyTrip()

    var body: some View {
        Group {
            if let journey = activeJourneyTrip {
                HikingTabContainerView(trip: journey)
                    .onReceive(NotificationCenter.default.publisher(for: .tripCompleted)) { _ in
                        withAnimation(.spring(response: 0.4)) {
                            activeJourneyTrip = nil
                            activePackingTrip = nil
                        }
                    }

            } else if let packing = activePackingTrip, !packing.isCompleted {
                NavigationStack {
                    PackingListView(trip: packing)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    TripStorage.shared.clearActiveTrip()
                                    activePackingTrip = nil
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                        Text("Beranda")
                                    }
                                }
                            }
                        }
                }
                .onReceive(NotificationCenter.default.publisher(for: .tripCompleted)) { _ in
                    withAnimation {
                        activeJourneyTrip = HikingJourneyStorage.shared.loadActiveJourneyTrip()
                    }
                }

            } else {
                NavigationStack {
                    HomeView()
                }
                .onReceive(NotificationCenter.default.publisher(for: .tripStarted)) { notif in
                    if let trip = notif.object as? Trip {
                        activePackingTrip = trip
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .tripCompleted)) { _ in
                    activePackingTrip = nil
                    activeJourneyTrip = nil
                }
            }
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let tripStarted   = Notification.Name("tripStarted")
    static let tripCompleted = Notification.Name("tripCompleted")
}
