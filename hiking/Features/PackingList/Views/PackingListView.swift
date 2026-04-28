// PackingListView.swift
import SwiftUI

struct PackingListView: View {
    @StateObject private var vm: PackingListViewModel
    @State private var addingTo: PackingCategory? = nil
    @State private var hikingStarted = false

    init(trip: Trip) {
        _vm = StateObject(wrappedValue: PackingListViewModel(trip: trip))
    }

    var body: some View {
        List {
            if !vm.uncheckedEssentials.isEmpty {
                EssentialWarningSection(uncheckedEssentials: vm.uncheckedEssentials)
            }

            PackingFilterRow(vm: vm)

            ForEach(vm.displayedCategories, id: \.self) { category in
                PackingCategorySection(
                    category: category,
                    items: vm.filteredItems(for: category),
                    onToggle: { vm.toggle(itemId: $0) },
                    onOwnershipChange: { id, ownership in vm.updateOwnership(itemId: id, ownership: ownership) },
                    onEssentialChange: { id, isEssential in vm.updateEssential(itemId: id, isEssential: isEssential) },
                    onDelete: { vm.deleteItems(at: $0, in: category) },
                    onAdd: { addingTo = category },
                    onCheckAll: { vm.checkAll(in: category) },
                    onUncheckAll: { vm.uncheckAll(in: category) }
                )
            }

            if vm.progress >= 1.0 && !hikingStarted {
                PackingDepartureSection(mountainName: vm.trip.mountainName) {
                    hikingStarted = true
                    TripStorage.shared.save(vm.trip)
                    TripStorage.shared.setActiveTrip(vm.trip)
                    HikingJourneyStorage.shared.saveJourney(tripId: vm.trip.id, currentDay: 1)
                    LiveActivityManager.shared.start(trip: vm.trip)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        NotificationCenter.default.post(name: .tripStarted, object: vm.trip)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(vm.trip.mountainName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar { PackingToolbar(vm: vm) }
        .sheet(item: $addingTo) { AddItemSheet(category: $0, vm: vm) }
    }
}

extension PackingCategory: Identifiable {
    public var id: String { rawValue }
}

#Preview {
    NavigationStack {
        PackingListView(trip: .preview)
    }
}
