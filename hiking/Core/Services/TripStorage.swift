//  TripStorage.swift

import Foundation

final class TripStorage {
    static let shared = TripStorage()
    private let key = "saved_trips_v1"
    private let activeTripKey = "active_trip_id"  
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    func loadAll() -> [Trip] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let trips = try? decoder.decode([Trip].self, from: data)
        else { return [] }
        return trips.sorted { $0.createdAt > $1.createdAt }
    }

    func save(_ trip: Trip) {
        var trips = loadAll()
        if let idx = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[idx] = trip
        } else {
            trips.insert(trip, at: 0)
        }
        persist(trips)
    }

    func delete(id: UUID) {
        var trips = loadAll()
        trips.removeAll { $0.id == id }
        persist(trips)
        // Kalau yang dihapus adalah active trip, clear juga
        if loadActiveTripId() == id {
            clearActiveTrip()
        }
    }

    func deleteAll() {
        UserDefaults.standard.removeObject(forKey: key)
        clearActiveTrip()
    }

    // MARK: - Active Trip
    func setActiveTrip(_ trip: Trip) {
        UserDefaults.standard.set(trip.id.uuidString, forKey: activeTripKey)
    }

    func clearActiveTrip() {
        UserDefaults.standard.removeObject(forKey: activeTripKey)
    }

    func loadActiveTripId() -> UUID? {
        guard let str = UserDefaults.standard.string(forKey: activeTripKey) else { return nil }
        return UUID(uuidString: str)
    }

    func loadActiveTrip() -> Trip? {
        guard let id = loadActiveTripId() else { return nil }
        return loadAll().first { $0.id == id }
    }

    private func persist(_ trips: [Trip]) {
        if let data = try? encoder.encode(trips) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
