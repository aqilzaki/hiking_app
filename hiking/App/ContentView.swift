import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MountainListView()
                .tabItem {
                    Label("Gunung", systemImage: "mountain.2.fill")
                }

            TripHistoryView()
                .tabItem {
                    Label("Riwayat", systemImage: "clock.fill")
                }
        }
    }
}
