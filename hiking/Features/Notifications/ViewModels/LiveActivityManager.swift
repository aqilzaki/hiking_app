import Foundation
import ActivityKit

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var activity: Activity<HikingActivityAttributes>? = nil

    private init() {}

    // MARK: - Start
    func start(trip: Trip) {
        let info = ActivityAuthorizationInfo()
        guard info.areActivitiesEnabled else {
            print("❌ Live Activities tidak diizinkan")
            return
        }

        // Simpan startDate ke disk
        let key = startDateKey(trip)
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(Date(), forKey: key)
        }

        let estimatedMinutes = trip.durationDays * 8 * 60

        let attributes = HikingActivityAttributes(
            tripId: trip.id.uuidString,
            grade: trip.grade.sortOrder,
            totalDays: trip.durationDays
        )

        let initialState = HikingActivityAttributes.ContentState(
            mountainName: trip.mountainName,
            elapsedMinutes: 0,
            estimatedTotalMinutes: estimatedMinutes,
            phase: .hiking,
            numberOfPeople: trip.numberOfPeople
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: staleDate()),
                pushType: nil
            )
            print("✅ Live Activity started: \(activity?.id ?? "nil")")
        } catch {
            print("❌ LiveActivity error: \(error.localizedDescription)")
        }
    }

    // MARK: - Resume (dipanggil saat app kembali aktif)
    func resumeIfNeeded(trip: Trip, currentDay: Int) {
        let estimatedMinutes = trip.durationDays * 8 * 60
        let elapsedMinutes   = elapsedMinutesSinceStart(trip: trip)

        let phase = currentPhase(elapsed: elapsedMinutes, estimated: estimatedMinutes)

        let existing = Activity<HikingActivityAttributes>.activities

        if let found = existing.first {
            // Activity masih hidup → pakai yang lama, update state terkini
            self.activity = found
            update(trip: trip, elapsedMinutes: elapsedMinutes)
            print("✅ Resumed & updated activity: \(found.id), elapsed: \(elapsedMinutes)m, phase: \(phase.rawValue)")
        } else {
            // Activity sudah mati (timeout / low memory) → start ulang
            print("🔄 No existing activity, restarting...")
            start(trip: trip)

            // Update ke posisi yang benar setelah activity terbuat
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.update( trip: trip, elapsedMinutes: elapsedMinutes)
            }
        }
    }

    // MARK: - Update
    func update(trip: Trip, elapsedMinutes: Int? = nil) {
        let elapsed = elapsedMinutes ?? elapsedMinutesSinceStart(trip: trip)
        let estimatedMinutes = trip.durationDays * 8 * 60

        let phase = currentPhase(elapsed: elapsed, estimated: estimatedMinutes)

        let newState = HikingActivityAttributes.ContentState(
            mountainName: trip.mountainName,
            elapsedMinutes: elapsed,
            estimatedTotalMinutes: estimatedMinutes,
            phase: phase,
            numberOfPeople: trip.numberOfPeople
        )

        Task {
            await activity?.update(.init(state: newState, staleDate: staleDate()))
        }
    }

    // MARK: - Stop
    func stop() {
        Task {
            let finalState = activity?.content.state ?? HikingActivityAttributes.ContentState(
                mountainName: "",
                elapsedMinutes: 0,
                estimatedTotalMinutes: 1,
                phase: .done,
                numberOfPeople: 1
            )
            await activity?.end(
                .init(state: finalState, staleDate: nil),
                dismissalPolicy: .after(Date().addingTimeInterval(10))
            )
            print("🛑 Live Activity stopped")
            
        }
        activity = nil
       
    }

    // MARK: - Helpers
    private func startDateKey(_ trip: Trip) -> String {
        "liveActivityStartDate_\(trip.id)"
    }

    /// Hitung berapa menit sudah berlalu sejak start, berdasarkan waktu nyata
    private func elapsedMinutesSinceStart(trip: Trip) -> Int {
        let startDate = UserDefaults.standard.object(forKey: startDateKey(trip)) as? Date ?? Date()
        return max(0, Int(Date().timeIntervalSince(startDate) / 60))
    }

    /// Tentukan fase berdasarkan progress
    private func currentPhase(elapsed: Int, estimated: Int) -> HikingPhase {
        let progress = Double(elapsed) / Double(estimated)
        switch progress {
        case ..<0.45: return .hiking
        case ..<0.55: return .summit
        case ..<0.90: return .descending
        default:      return .done
        }
    }

    /// staleDate 1 jam dari sekarang 
    private func staleDate() -> Date {
        Date().addingTimeInterval(60 * 60)
    }
    
   

    // MARK: - Alert per fase
    private func alertConfiguration(for phase: HikingPhase, mountainName: String) -> AlertConfiguration? {
        switch phase {
        case .summit:
            return AlertConfiguration(
                title: "🏔 Kamu di puncak!",
                body: "Selamat! Kamu telah mencapai puncak \(mountainName).",
                sound: .default
            )
        case .descending:
            return AlertConfiguration(
                title: "⬇️ Mulai turun",
                body: "Tetap hati-hati saat perjalanan turun.",
                sound: .default
            )
        case .done:
            return AlertConfiguration(
                title: "🎉 Pendakian selesai!",
                body: "Kamu berhasil menyelesaikan pendakian \(mountainName). Luar biasa!",
                sound: .default
            )
        case .hiking:
            return nil // Tidak perlu alert saat fase normal
        case .preparing:
            return AlertConfiguration(
                title: "📢 cek cek cek!",
                body: "jangan lupa cek lagi barangnya. sebelum summit attack!",
                sound: .default
                )
        }
    }
}
