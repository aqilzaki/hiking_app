// HomeView.swift
import SwiftUI

struct HomeView: View {
    @State private var selectedMountain: Mountain? = nil
    @State private var showStarter = false
    @State private var searchText = ""
    @State private var activeTrip: Trip? = TripStorage.shared.loadActiveTrip()

    let mountains = MountainDatabase.all
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var featuredMountains: [Mountain] {
        Array(mountains.filter { $0.grade == .ii || $0.grade == .i }.prefix(3))
    }

    var filteredMountains: [Mountain] {
        if searchText.isEmpty {
            return mountains
        } else {
            return mountains.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.province.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Carousel
                if let trip = activeTrip, searchText.isEmpty {
                    // ← carousel hilang saat search aktif
                    Button {
                        NotificationCenter.default.post( name: .tripBerangkat, object: trip)
                    } label: {
                        FeaturedCarousel(
                            activeTrip: (
                                name: trip.mountainName,
                                province: trip.mountainProvince,
                                grade: trip.grade,
                                day: HikingJourneyStorage.shared.loadCurrentDay(tripId: trip.id) ?? 1,
                                totalDays: trip.durationDays
                            ),
                            mountains: featuredMountains
                        )
                        .frame(height: 240)
                    }
                    .buttonStyle(.plain)
                }

                // MARK: - Jelajahi Gunung
                VStack(alignment: .leading, spacing: 24) {

                    // Kalau search kosong tampilkan header
                    if searchText.isEmpty {
                        Text("Jelajahi Gunung")
                            .font(.title3.bold())
                            .padding(.horizontal, 16)
                    }

                    if filteredMountains.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)
                            Text("Gunung \"\(searchText)\" tidak ditemukan")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)

                    } else if searchText.isEmpty {
                        // Grid per grade
                        ForEach(Grade.allCases, id: \.rawValue) { grade in
                            let gradeMountains = filteredMountains.filter { $0.grade == grade }
                            if !gradeMountains.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 8) {
                                        Text(grade.rawValue)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(gradeColor(grade))
                                            .clipShape(Capsule())

                                        Text(grade.difficultyLabel)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 16)

                                    LazyVGrid(columns: columns, spacing: 12) {
                                        ForEach(gradeMountains) { mountain in
                                            MountainGridCard(mountain: mountain) {
                                                selectedMountain = mountain
                                                showStarter = true
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }

                    } else {
                        // Hasil search — flat grid tanpa grouping grade
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredMountains) { mountain in
                                MountainGridCard(mountain: mountain) {
                                    selectedMountain = mountain
                                    showStarter = true
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Halo, Pendaki! 👋")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Cari gunung atau provinsi...")  // ← di sini
        .navigationDestination(isPresented: $showStarter) {
            if let m = selectedMountain {
                StarterView(mountain: m)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .tripStarted)) { notif in
            activeTrip = notif.object as? Trip
        }
        .onReceive(NotificationCenter.default.publisher(for: .tripCompleted)) { _ in
            activeTrip = nil
        }
    }
}

// MARK: - Safe Array Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
