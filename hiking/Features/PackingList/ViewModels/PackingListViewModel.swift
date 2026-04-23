//  PackingListViewModel.swift
//  hiking

import SwiftUI
import Combine

// MARK: - PackingItem Priority Extension
extension PackingItem {
    var priorityOrder: Int {
        switch (isEssential, ownership) {
        case (true, .sewa):     return 0
        case (true, .bersama):  return 1
        case (true, .pribadi):  return 2
        case (false, .sewa):    return 3
        case (false, .bersama): return 4
        case (false, .pribadi): return 5
        }
    }
}

// MARK: - ViewModel
@MainActor
final class PackingListViewModel: ObservableObject {
    @Published var trip: Trip
    @Published var showEssentialOnly: Bool         = false
    @Published var ownershipFilter: ItemOwnership? = nil

    private let storage = TripStorage.shared

    init(trip: Trip) { self.trip = trip }

    // MARK: - Computed
    var displayedCategories: [PackingCategory] {
        PackingCategory.allCases.filter { !filteredItems(for: $0).isEmpty }
    }

    var checkedCount: Int { trip.checkedCount }
    var totalCount: Int   { trip.totalCount }
    var progress: Double  { trip.progress }

    var uncheckedEssentials: [PackingItem] {
        trip.items.filter { $0.isEssential && !$0.isChecked }
    }

    var progressLabel: String {
        switch progress {
        case 0:      return "Belum mulai packing 🎒"
        case ..<0.3: return "Baru mulai nih!"
        case ..<0.6: return "Lumayan, lanjut terus!"
        case ..<1.0: return "Hampir penuh! 💪"
        default:     return "Tas sudah penuh! ✅"
        }
    }

    var progressColor: Color {
        switch progress {
        case ..<0.4: return .orange
        case ..<0.8: return .blue
        default:     return .green
        }
    }

    // MARK: - Filter + Sort (hanya 1 definisi)
    func filteredItems(for category: PackingCategory) -> [PackingItem] {
        trip.items
            .filter { item in
                guard item.category == category else { return false }
                if showEssentialOnly && !item.isEssential { return false }
                if let filter = ownershipFilter, item.ownership != filter { return false }
                return true
            }
            .sorted { $0.priorityOrder < $1.priorityOrder }
    }

    // MARK: - Toggle
    func toggle(itemId: UUID) {
        guard let idx = trip.items.firstIndex(where: { $0.id == itemId }) else { return }
        trip.items[idx].isChecked.toggle()
        storage.save(trip)
        if trip.isCompleted {
            NotificationCenter.default.post(name: .tripCompleted, object: trip)
        }
    }

    // MARK: - Check / Uncheck
    func checkAll(in category: PackingCategory) {
        for idx in trip.items.indices where trip.items[idx].category == category {
            trip.items[idx].isChecked = true
        }
        storage.save(trip)
        if trip.isCompleted {
            NotificationCenter.default.post(name: .tripCompleted, object: trip)
        }
    }

    func uncheckAll(in category: PackingCategory) {
        for idx in trip.items.indices where trip.items[idx].category == category {
            trip.items[idx].isChecked = false
        }
        storage.save(trip)
    }

    func checkAllItems() {
        for idx in trip.items.indices { trip.items[idx].isChecked = true }
        storage.save(trip)
        NotificationCenter.default.post(name: .tripCompleted, object: trip)
    }

    func uncheckAllItems() {
        for idx in trip.items.indices { trip.items[idx].isChecked = false }
        storage.save(trip)
    }

    // MARK: - Update Tag
    func updateOwnership(itemId: UUID, ownership: ItemOwnership) {
        guard let idx = trip.items.firstIndex(where: { $0.id == itemId }) else { return }
        trip.items[idx].ownership = ownership
        storage.save(trip)
    }

    func updateEssential(itemId: UUID, isEssential: Bool) {
        guard let idx = trip.items.firstIndex(where: { $0.id == itemId }) else { return }
        trip.items[idx].isEssential = isEssential
        storage.save(trip)
    }

    // MARK: - Add / Delete
    func addItem(
        name: String,
        category: PackingCategory,
        isEssential: Bool = false,
        ownership: ItemOwnership = .pribadi
    ) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        trip.items.append(PackingItem(
            name: name,
            isEssential: isEssential,
            category: category,
            ownership: ownership
        ))
        storage.save(trip)
    }

    func deleteItems(at offsets: IndexSet, in category: PackingCategory) {
        let catItems       = trip.items.enumerated().filter { $0.element.category == category }
        let globalIndices  = offsets.map { catItems[$0].offset }
        trip.items.remove(atOffsets: IndexSet(globalIndices))
        storage.save(trip)
    }
}
