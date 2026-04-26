import SwiftUI

struct PackingListView: View {
    @StateObject private var vm: PackingListViewModel
    @State private var addingTo: PackingCategory? = nil
    @State private var hikingStarted              = false
    @State private var navigateToTracking         = false
    
    init(trip: Trip) {
        _vm = StateObject(wrappedValue: PackingListViewModel(trip: trip))
    }

    var body: some View {
        List {
           

            // Essential warning
            if !vm.uncheckedEssentials.isEmpty {
                essentialWarning
            }

            // Filter
            FilterRow(vm: vm)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            // Categories
            ForEach(vm.displayedCategories, id: \.self) { category in
                categorySection(category)
            }

            // Departure
            if vm.progress >= 1.0 && !hikingStarted {
                DepartureButton(mountainName: vm.trip.mountainName) {
                    hikingStarted = true
                    HikingJourneyStorage.shared.saveJourney(tripId: vm.trip.id, currentDay: 1)
                    LiveActivityManager.shared.start(trip: vm.trip)
                    navigateToTracking = true
    
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(vm.trip.mountainName)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigateToTracking) {
            HikingTabContainerView(trip: vm.trip)
        }
        .toolbar { toolbarContent }
        .sheet(item: $addingTo) { AddItemSheet(category: $0, vm: vm) }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button { vm.checkAllItems() } label: {
                    Label("Centang Semua", systemImage: "checkmark.circle.fill")
                }
                Button { vm.uncheckAllItems() } label: {
                    Label("Hapus Semua Centang", systemImage: "circle")
                }
                Divider()
                Button { vm.showEssentialOnly.toggle() } label: {
                    Label(
                        vm.showEssentialOnly ? "Tampilkan Semua" : "Esensial Saja",
                        systemImage: vm.showEssentialOnly ? "list.bullet" : "star.fill"
                    )
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }

    // MARK: - Essential Warning
    private var essentialWarning: some View {
        Section {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(vm.uncheckedEssentials.count) item penting belum di-cek")
                        .font(.subheadline.weight(.semibold))
                    Text(vm.uncheckedEssentials.prefix(2).map { $0.name }.joined(separator: ", ")
                         + (vm.uncheckedEssentials.count > 2 ? "..." : ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 2)
        }
        .listRowBackground(Color.orange.opacity(0.08))
    }

    // MARK: - Category Section
    @ViewBuilder
    private func categorySection(_ category: PackingCategory) -> some View {
        let items = vm.filteredItems(for: category)
        if !items.isEmpty {
            Section {
                ForEach(items) { item in
                    PackingItemRow(
                        item: item,
                        onToggle: { vm.toggle(itemId: item.id) },
                        onOwnershipChange: { vm.updateOwnership(itemId: item.id, ownership: $0) },
                        onEssentialChange: { vm.updateEssential(itemId: item.id, isEssential: $0) }
                    )
                }
                .onDelete { vm.deleteItems(at: $0, in: category) }

                Button { addingTo = category } label: {
                    Label("Tambah item", systemImage: "plus.circle")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            } header: {
                HStack {
                    Label(category.rawValue, systemImage: category.sfSymbol)
                    Spacer()
                    let checked    = items.filter { $0.isChecked }.count
                    let allChecked = checked == items.count

                    Button {
                        allChecked ? vm.uncheckAll(in: category) : vm.checkAll(in: category)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: allChecked ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 13))
                                .foregroundStyle(allChecked ? Color.green : Color.secondary)
                            Text("\(checked)/\(items.count)")
                                .font(.caption)
                                .foregroundStyle(allChecked ? Color.green : Color.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(response: 0.2), value: allChecked)
                }
            }
        }
    }
}

extension PackingCategory: Identifiable {
    public var id: String { rawValue }
}
