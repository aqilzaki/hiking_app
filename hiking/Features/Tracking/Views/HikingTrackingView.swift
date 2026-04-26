// HikingTrackingView.swift
import SwiftUI
import DotLottie
import Combine

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
            currentDay = calculateCurrentDay()
            Task {
                let granted = await NotificationManager.shared.requestPermission()
                if granted {
                    NotificationManager.shared.schedulePackingReminder(trip: trip)
                }
            }
        }
        .onReceive(
            Timer.publish(every: 10, on: .main, in: .common).autoconnect()
        ) { _ in
            currentDay = calculateCurrentDay()
            LiveActivityManager.shared.update(trip: trip)
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


    // MARK: - Finish Trip
    private func finishTrip() {
        HikingJourneyStorage.shared.clearJourney(tripId: trip.id)
        TripStorage.shared.clearActiveTrip()
        NotificationCenter.default.post(name: .tripCompleted, object: trip)
        dismiss()
    }
    
    func calculateCurrentDay() -> Int {
        let key = "liveActivityStartDate_\(trip.id)"
        
        guard let startDate = UserDefaults.standard.object(forKey: key) as? Date else {
            return 1
        }
        
        let elapsedMinutes = Int(Date().timeIntervalSince(startDate) / 60)
        
        let minutesPerDay = 8 * 60
        let day = (elapsedMinutes / minutesPerDay) + 1
        
        return min(day, totalDays)
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

