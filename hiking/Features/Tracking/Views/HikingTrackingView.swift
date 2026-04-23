// HikingTrackingView.swift
import SwiftUI
import DotLottie

struct HikingTrackingView: View {
    let trip: Trip
    @State private var currentDay: Int = 1
    @State private var showFinishConfirm = false
    @Environment(\.dismiss) private var dismiss

    var totalDays: Int { trip.durationDays }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                AnimationView()
                    .frame(width: 400, height: 300)
                    .offset(y: 10)

                VStack(spacing: 12) {
                    DayProgressView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        gradeColor: gradeColor(trip.grade)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                    // MARK: - Debug Controls
                    #if DEBUG
                    debugControls
                    #endif

                    NotificationCardView(
                        currentDay: currentDay,
                        totalDays: totalDays,
                        mountainName: trip.mountainName
                    )
                    .padding(.horizontal, 16)

                    TripInfoCardView(trip: trip)
                        .padding(.horizontal, 16)

                    // MARK: - Finish Button (muncul saat hari terakhir)
                    if currentDay >= totalDays {
                        Button {
                            showFinishConfirm = true
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
        .onAppear {
            currentDay = HikingJourneyStorage.shared.loadCurrentDay(tripId: trip.id) ?? 1
            Task {
                let granted = await NotificationManager.shared.requestPermission()
                if granted {
                    NotificationManager.shared.schedulePackingReminder(trip: trip)
                }
            }
        }
        .alert("Kamu udah selesai mendaki belum?", isPresented: $showFinishConfirm) {
            Button("Belum", role: .cancel) { }
            Button("Udah, Selesai! 🎉", role: .destructive) {
                finishTrip()
            }
        } message: {
            Text("Pastikan kamu sudah turun dengan selamat dari \(trip.mountainName) sebelum menyelesaikan pendakian.")
        }
    }

    // MARK: - Debug Controls
    #if DEBUG
    private var debugControls: some View {
        VStack(spacing: 8) {
            Text("🛠 DEBUG")
                .font(.caption2.bold())
                .foregroundStyle(.orange)

            HStack(spacing: 12) {
                // Mundur hari
                Button {
                    guard currentDay > 1 else { return }
                    currentDay -= 1
                    HikingJourneyStorage.shared.saveJourney(tripId: trip.id, currentDay: currentDay)
                } label: {
                    Label("Hari -1", systemImage: "minus.circle")
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // Maju hari
                Button {
                    guard currentDay < totalDays else { return }
                    currentDay += 1
                    HikingJourneyStorage.shared.saveJourney(tripId: trip.id, currentDay: currentDay)
                } label: {
                    Label("Hari +1", systemImage: "plus.circle")
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // Langsung ke hari terakhir
                Button {
                    currentDay = totalDays
                    HikingJourneyStorage.shared.saveJourney(tripId: trip.id, currentDay: currentDay)
                } label: {
                    Label("Hari Terakhir", systemImage: "forward.end.fill")
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.15))
                        .foregroundStyle(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            Text("Hari \(currentDay) dari \(totalDays)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.orange.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
    #endif

    // MARK: - Finish Trip
    private func finishTrip() {
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
            fileName: "Traveler",
            config: AnimationConfig(autoplay: true, loop: true)
        )
        .view()
    }
}
