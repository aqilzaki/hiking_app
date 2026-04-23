//
//  HikingJourneyStorage.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


//  HikingJourneyStorage.swift
//  hiking

import Foundation

final class HikingJourneyStorage {
    static let shared = HikingJourneyStorage()
    private let activeTripKey   = "active_hiking_trip_id"
    private let currentDayKey   = "active_hiking_current_day"

    private init() {}

    // Simpan trip yang sedang berjalan (berbeda dari packing)
    func saveJourney(tripId: UUID, currentDay: Int) {
        UserDefaults.standard.set(tripId.uuidString, forKey: activeTripKey)
        UserDefaults.standard.set(currentDay, forKey: currentDayKey)
    }

    func saveCurrentDay(tripId: UUID, day: Int) {
        UserDefaults.standard.set(tripId.uuidString, forKey: activeTripKey)
        UserDefaults.standard.set(day, forKey: currentDayKey)
    }

    func loadActiveJourneyTripId() -> UUID? {
        guard let str = UserDefaults.standard.string(forKey: activeTripKey) else { return nil }
        return UUID(uuidString: str)
    }

    func loadCurrentDay(tripId: UUID) -> Int? {
        guard let str = UserDefaults.standard.string(forKey: activeTripKey),
              str == tripId.uuidString else { return nil }
        let day = UserDefaults.standard.integer(forKey: currentDayKey)
        return day > 0 ? day : 1
    }

    func clearJourney(tripId: UUID) {
        UserDefaults.standard.removeObject(forKey: activeTripKey)
        UserDefaults.standard.removeObject(forKey: currentDayKey)
    }

    func hasActiveJourney() -> Bool {
        return loadActiveJourneyTripId() != nil
    }

    // Load trip yang sedang dalam perjalanan
    func loadActiveJourneyTrip() -> Trip? {
        guard let id = loadActiveJourneyTripId() else { return nil }
        return TripStorage.shared.loadAll().first { $0.id == id }
    }
}