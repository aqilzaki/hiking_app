//  HikingTrackingView.swift
//  hiking

import SwiftUI
import DotLottie

struct HikingTrackingView: View {
    let trip: Trip
    @State private var currentDay: Int = 1
    @State private var isActive: Bool = true
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    var totalDays: Int { trip.durationDays }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Scene Ilustrasi
                ZStack(alignment: .bottom) {
                    // Background langit
                    LinearGradient(
                        colors: [
                            Color(red: 0.82, green: 0.91, blue: 0.95),
                            Color(red: 0.93, green: 0.96, blue: 0.98)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    // Gunung background
                    MountainSceneView()

                    // Trail path + pin
                    TrailPathView(
                        totalDays: totalDays,
                        currentDay: currentDay,
                        gradeColor: gradeColor(trip.grade)
                    )
                    .frame(height: 130)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 80)

                    // Lottie hiker animation
                    AnimationView()
                        .frame(width: 160, height: 200)
                        .offset(y: 10)
                }
                .frame(height: 340)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                VStack(spacing: 12) {
                    // Day progress bar
                    DayProgressView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        gradeColor: gradeColor(trip.grade)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                    // Notifikasi
                    NotificationCardView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        mountainName: trip.mountainName
                    )
                    .padding(.horizontal, 16)

                    // Trip info
                    TripInfoCardView(trip: trip)
                        .padding(.horizontal, 16)

                    // Selesai button
                    if currentDay >= totalDays {
                        Button {
                            finishTrip()
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
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(trip.mountainName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // ← tidak bisa back sembarangan
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Bisa minimize tapi Live Activity tetap jalan
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Minimize")
                    }
                }
            }
        }
        .onAppear {
            // Restore state dari storage
            currentDay = HikingJourneyStorage.shared.loadCurrentDay(tripId: trip.id) ?? 1
            isActive = true

            // Pastikan Live Activity tetap jalan
            LiveActivityManager.shared.resumeIfNeeded(trip: trip, currentDay: currentDay)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                // Simpan state saat app ke background
                HikingJourneyStorage.shared.saveCurrentDay(tripId: trip.id, day: currentDay)
            }
        }
    }

    private func finishTrip() {
        LiveActivityManager.shared.stop()
        HikingJourneyStorage.shared.clearJourney(tripId: trip.id)
        TripStorage.shared.clearActiveTrip()
        NotificationCenter.default.post(name: .tripCompleted, object: trip)
        dismiss()
    }
}

// MARK: - Lottie Animation
struct AnimationView: View {
    var body: some View {
        DotLottieAnimation(
            webURL: "https://lottie.host/embed/d91c2609-12b6-4d46-9870-e32bacf781cf/4SDvBUNBXg.lottie"
        ).view()
    }
}
