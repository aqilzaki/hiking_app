//
//  TripStorage.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import Foundation

final class TripStorage {
    static let shared = TripStorage()
    private let key = "saved_trips_v1"
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
    }

    func deleteAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private func persist(_ trips: [Trip]) {
        if let data = try? encoder.encode(trips) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}