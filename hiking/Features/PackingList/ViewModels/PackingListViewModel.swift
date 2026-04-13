//
//  PackingListViewModel.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI
import Combine

final class PackingListViewModel: ObservableObject {
    @Published var trip: Trip
    @Published var filterCategory: PackingCategory? = nil
    @Published var showEssentialOnly: Bool = false

    private let storage = TripStorage.shared

    init(trip: Trip) {
        self.trip = trip
    }

    var displayedCategories: [PackingCategory] {
        PackingCategory.allCases.filter { cat in
            !filteredItems(for: cat).isEmpty
        }
    }

    func filteredItems(for category: PackingCategory) -> [PackingItem] {
        trip.items.filter { item in
            guard item.category == category else { return false }
            if showEssentialOnly && !item.isEssential { return false }
            return true
        }
    }

    var checkedCount: Int { trip.checkedCount }
    var totalCount: Int { trip.totalCount }
    var progress: Double { trip.progress }

    var uncheckedEssentials: [PackingItem] {
        trip.items.filter { $0.isEssential && !$0.isChecked }
    }

    func toggle(itemId: UUID) {
        guard let idx = trip.items.firstIndex(where: { $0.id == itemId }) else { return }
        trip.items[idx].isChecked.toggle()
        storage.save(trip)
    }

    func checkAll(in category: PackingCategory) {
        for idx in trip.items.indices where trip.items[idx].category == category {
            trip.items[idx].isChecked = true
        }
        storage.save(trip)
    }

    func addItem(name: String, category: PackingCategory, isEssential: Bool = false) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        trip.items.append(PackingItem(name: name, isEssential: isEssential, category: category))
        storage.save(trip)
    }

    func deleteItems(at offsets: IndexSet, in category: PackingCategory) {
        let catItems = trip.items.enumerated().filter { $0.element.category == category }
        let globalIndices = offsets.map { catItems[$0].offset }
        trip.items.remove(atOffsets: IndexSet(globalIndices))
        storage.save(trip)
    }
}