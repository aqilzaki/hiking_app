//  LiveActivityManager.swift
//  hiking

import Foundation
import ActivityKit

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var activity: Activity<HikingActivityAttributes>? = nil
    private var timer: Timer? = nil

    private init() {}  // ← tambah ini

    // MARK: - Start
    func start(trip: Trip) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

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
            await activity?.end(
                .init(
                    state: activity?.content.state ?? .init(
                        mountainName: "",
                        elapsedMinutes: 0,
                        estimatedTotalMinutes: 1,
                        phase: .done,
                        numberOfPeople: 1
                    ),
                    staleDate: nil
                ),
                dismissalPolicy: .after(Date().addingTimeInterval(10))
            )
        }
        activity = nil
    }

    // Tambah fungsi ini di LiveActivityManager
    func resumeIfNeeded(trip: Trip, currentDay: Int) {
        // Cek apakah sudah ada Live Activity yang berjalan
        let existing = Activity<HikingActivityAttributes>.activities
        if !existing.isEmpty {
            // Sudah ada, tidak perlu start baru
            self.activity = existing.first
            return
        }

        // Tidak ada Live Activity → start baru
        let estimatedMinutes = trip.durationDays * 8 * 60
        let elapsedMinutes   = (currentDay - 1) * 8 * 60

        let attributes = HikingActivityAttributes(
            tripId: trip.id.uuidString,
            grade: trip.grade.sortOrder,
            totalDays: trip.durationDays
        )

        let progress = Double(elapsedMinutes) / Double(estimatedMinutes)
        let phase: HikingPhase = switch progress {
            case ..<0.45: .hiking
            case ..<0.55: .summit
            case ..<0.9:  .descending
            default:      .done
        }

        let state = HikingActivityAttributes.ContentState(
            mountainName: trip.mountainName,
            elapsedMinutes: elapsedMinutes,
            estimatedTotalMinutes: estimatedMinutes,
            phase: phase,
            numberOfPeople: trip.numberOfPeople
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            startTimer(estimatedMinutes: estimatedMinutes, trip: trip)
        } catch {
            print("Resume LiveActivity error: \(error)")
        }
    }
    
    
    // MARK: - Timer
    private func startTimer(estimatedMinutes: Int, trip: Trip) {
        var elapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            elapsed += 1
            guard let self else { return }

            let progress = Double(elapsed) / Double(estimatedMinutes)
            let phase: HikingPhase = switch progress {
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
