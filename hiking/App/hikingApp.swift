// hikingApp.swift
import SwiftUI

@main
struct hikingApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// MARK: - Root View
struct RootView: View {
    @State private var activeJourneyTrip: Trip? = nil
    @State private var path = NavigationPath()  // ← tambah ini

    var body: some View {
        NavigationStack(path: $path) {  // ← pass path
            HomeView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .tripBerangkat)) { notif in
            if let trip = notif.object as? Trip {
                // Reset stack ke root dulu — PackingListView hilang
                path = NavigationPath()  // ← clear semua history navigation
                
                // Tunggu stack reset selesai baru buka fullScreenCover
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.4)) {
                        activeJourneyTrip = trip
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .tripCompleted)) { _ in
            withAnimation(.spring(response: 0.4)) {
                activeJourneyTrip = nil
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .dismissToHome)) { _ in
            withAnimation(.spring(response: 0.4)) {
                activeJourneyTrip = nil
                path = NavigationPath()  // ← reset stack juga saat dismiss
            }
        }
        .fullScreenCover(item: $activeJourneyTrip) { journey in
            HikingTabContainerView(trip: journey)
        }
    }
}


// MARK: - Notification Names
extension Notification.Name {
    static let tripStarted   = Notification.Name("tripStarted")
    static let tripBerangkat = Notification.Name("tripBerangkat")
    static let tripCompleted = Notification.Name("tripCompleted")
    static let dismissToHome = Notification.Name("dismissToHome")
}
