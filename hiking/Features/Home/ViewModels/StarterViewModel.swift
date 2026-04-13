import SwiftUI

@MainActor
final class StarterViewModel: ObservableObject {
    @Published var selectedMountain: Mountain? = nil
    @Published var startDate: Date             = Date()
    @Published var endDate: Date               = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    @Published var jumlahOrang: Int            = 2
    @Published var selectedImage: UIImage?     = nil
    @Published var showMountainPicker: Bool    = false
    @Published var showImagePicker: Bool       = false

    var canProceed: Bool { selectedMountain != nil }

    var durasiHari: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }

    var estimasiText: String {
        selectedMountain?.durationNote ?? "\(durasiHari) Hari"
    }

    func createAndStartTrip() {
        guard let mountain = selectedMountain else { return }

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
    }
}