//
//  JourneyChecklistViewModel.swift
//  hiking
//
//  Created by muhammad aqil zaki on 26/04/26.
//


// JourneyChecklistViewModel.swift
import Foundation
import Combine

@MainActor
final class JourneyChecklistViewModel: ObservableObject {
    @Published private var items: [PackingItem]

    init(trip: Trip) {
        self.items = trip.items
            .filter { $0.isEssential }
            .map { item in
                var copy = item
                copy.isChecked = false
                copy.id = UUID()
                return copy
            }
    }

    var checkedCount: Int { items.filter { $0.isChecked }.count }
    var totalCount: Int { items.count }
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(checkedCount) / Double(totalCount)
    }

    var categories: [PackingCategory] {
        let cats = items.map { $0.category }
        return PackingCategory.allCases.filter { cats.contains($0) }
    }

    func items(for category: PackingCategory) -> [PackingItem] {
        items.filter { $0.category == category }
    }

    func toggle(itemId: UUID) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        items[index].isChecked.toggle()
    }
}
