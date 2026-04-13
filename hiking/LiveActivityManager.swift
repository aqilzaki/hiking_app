//  LiveActivityManager.swift
//  hiking

import Foundation
import ActivityKit

@MainActor
final class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    private var activity: Activity<HikingActivityAttributes>?
    private var timer: Timer?

    private init() {}

    // MARK: - Start saat "Yuk Berangkat" ditekan
    func start(trip: Trip) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        // Hitung estimasi menit dari durationDays
        let estimatedMinutes = trip.durationDays * 8 * 60 // asumsi 8 jam/hari mendaki

        let attributes = HikingActivityAttributes(
            tripId: trip.id.uuidString,
            grade: trip.grade.sortOrder
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
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            startTimer(estimatedMinutes: estimatedMinutes, trip: trip)
        } catch {
            print("LiveActivity error: \(error)")
        }
    }

    // MARK: - Update fase
    func updatePhase(_ phase: HikingPhase, trip: Trip, elapsedMinutes: Int) {
        let estimatedMinutes = trip.durationDays * 8 * 60
        let newState = HikingActivityAttributes.ContentState(
            mountainName: trip.mountainName,
            elapsedMinutes: elapsedMinutes,
            estimatedTotalMinutes: estimatedMinutes,
            phase: phase,
            numberOfPeople: trip.numberOfPeople
        )
        Task {
            await activity?.update(.init(state: newState, staleDate: nil))
        }
    }

    // MARK: - Stop
    func stop() {
        timer?.invalidate()
        timer = nil
        Task {
            await activity?.end(.init(state: activity?.content.state ?? .init(
                mountainName: "",
                elapsedMinutes: 0,
                estimatedTotalMinutes: 1,
                phase: .done,
                numberOfPeople: 1
            ), staleDate: nil), dismissalPolicy: .after(Date().addingTimeInterval(10)))
        }
        activity = nil
    }

    // MARK: - Timer simulasi elapsed time
    private func startTimer(estimatedMinutes: Int, trip: Trip) {
        var elapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            elapsed += 1
            guard let self else { return }

            // Update fase otomatis berdasarkan progress
            let progress = Double(elapsed) / Double(estimatedMinutes)
            let phase: HikingPhase = switch progress {
                case ..<0.1:  .hiking
                case ..<0.45: .hiking
                case ..<0.55: .summit
                case ..<0.9:  .descending
                default:      .done
            }

            Task { @MainActor in
                self.updatePhase(phase, trip: trip, elapsedMinutes: elapsed)
                if phase == .done { self.stop() }
            }
        }
    }
}