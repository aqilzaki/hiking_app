//
//  TripHistoryViewModel.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI

final class TripHistoryViewModel: ObservableObject {
    @Published var trips: [Trip] = []

    private let storage = TripStorage.shared

    init() { load() }

    func load() {
        trips = storage.loadAll()
    }

    func delete(id: UUID) {
        storage.delete(id: id)
        load()
    }

    func deleteAll() {
        storage.deleteAll()
        trips = []
    }
}