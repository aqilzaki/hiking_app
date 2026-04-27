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
    @State private var path = NavigationPath()  

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .tripBerangkat)) { notif in
            if let trip = notif.object as? Trip {          
                path = NavigationPath()
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
                path = NavigationPath()  
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
