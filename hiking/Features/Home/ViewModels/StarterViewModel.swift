import SwiftUI
import Combine

@MainActor
final class StarterViewModel: ObservableObject {
    @Published var selectedMountain: Mountain? = nil {
        didSet { enforceMinimumDuration() }
    }
    @Published var startDate: Date = Date() {
        didSet { enforceMinimumDuration() }
    }
    @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    @Published var jumlahOrang: Int         = 2
    @Published var showMinDurationWarning: Bool = false
    @Published var tripCreated: Bool        = false
    @Published var createdTrip: Trip?       = nil

    var canProceed: Bool { selectedMountain != nil }

    var durasiHari: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }

    var minDurasiHari: Int {
        selectedMountain?.durationDays.lowerBound ?? 1
    }

    var minimumEndDate: Date {
        Calendar.current.date(byAdding: .day, value: minDurasiHari, to: startDate) ?? startDate
    }

    var estimasiText: String {
        guard let mountain = selectedMountain else {
            return "\(durasiHari) Hari"
        }
        let min = mountain.durationDays.lowerBound
        let max = mountain.durationDays.upperBound
        if min == max {
            return "\(min) Hari (min. \(min) hari)"
        }
        return "\(durasiHari) Hari (min. \(min) – \(max) hari)"
    }

    var durasiValid: Bool {
        durasiHari >= minDurasiHari
    }

    private func enforceMinimumDuration() {
        let minEnd = minimumEndDate
        if endDate < minEnd {
            endDate = minEnd
            showMinDurationWarning = true

            Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                showMinDurationWarning = false
            }
        }
    }

    func createAndStartTrip() {
        guard let mountain = selectedMountain, durasiValid else { return }

        let config = TripConfig(
            numberOfPeople: jumlahOrang,
            packSize: .standar,
            includeCooking: true,
            includeSleeping: true
        )

        let items = PackingRecommendation.generate(mountain: mountain, config: config)

        let trip = Trip(
            mountainId: mountain.id,
            mountainName: mountain.name,
            mountainProvince: mountain.province,
            grade: mountain.grade,
            numberOfPeople: jumlahOrang,
            durationDays: max(1, durasiHari),
            items: items
        )

        TripStorage.shared.save(trip)
        TripStorage.shared.setActiveTrip(trip)
        NotificationCenter.default.post(name: .tripStarted, object: trip)
        createdTrip = trip
        tripCreated = true
    }
}
