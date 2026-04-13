//
//  PackingListView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI

struct PackingListView: View {
    @StateObject private var vm: PackingListViewModel
    @State private var addingTo: PackingCategory? = nil
    @Environment(\.dismiss) private var dismiss

    init(trip: Trip) {
        _vm = StateObject(wrappedValue: PackingListViewModel(trip: trip))
    }

    var body: some View {
        List {
            progressHeader
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            if !vm.uncheckedEssentials.isEmpty {
                essentialWarning
            }

            filterRow
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            ForEach(vm.displayedCategories, id: \.self) { category in
                categorySection(category)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(vm.trip.mountainName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        vm.showEssentialOnly.toggle()
                    } label: {
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
        .sheet(item: $addingTo) { category in
            AddItemSheet(category: category, vm: vm)
        }
    }

    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(vm.checkedCount) dari \(vm.totalCount) item")
                        .font(.headline)
                    Text(progressLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color(.systemFill), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: vm.progress)
                        .stroke(progressColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.5), value: vm.progress)
                    Text("\(Int(vm.progress * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .frame(width: 56, height: 56)
            }
            ProgressView(value: vm.progress)
                .tint(progressColor)
                .animation(.spring(response: 0.5), value: vm.progress)
        }
        .padding(16)
    }

    private var progressLabel: String {
        switch vm.progress {
        case 0:       return "Belum mulai packing 🎒"
        case ..<0.5:  return "Baru mulai, ayo lanjut!"
        case ..<1.0:  return "Hampir selesai!"
        default:      return "Semua sudah terpacking! ✅"
        }
    }

    private var progressColor: Color {
        switch vm.progress {
        case ..<0.4:  return .orange
        case ..<0.8:  return .blue
        default:      return .green
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

    // MARK: - Filter Row
    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(label: "Semua", isSelected: !vm.showEssentialOnly) {
                    vm.showEssentialOnly = false
                }
                FilterPill(label: "⭐ Esensial", isSelected: vm.showEssentialOnly, color: .orange) {
                    vm.showEssentialOnly = true
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Category Section
    @ViewBuilder
    private func categorySection(_ category: PackingCategory) -> some View {
        let items = vm.filteredItems(for: category)
        if !items.isEmpty {
            Section {
                ForEach(items) { item in
                    PackingItemRow(item: item) {
                        vm.toggle(itemId: item.id)
                    }
                }
                .onDelete { offsets in
                    vm.deleteItems(at: offsets, in: category)
                }
                Button {
                    addingTo = category
                } label: {
                    Label("Tambah item", systemImage: "plus.circle")
                        .font(.subheadline)
                        .foregroundStyle(.accentColor)
                }
            } header: {
                HStack {
                    Label(category.rawValue, systemImage: category.sfSymbol)
                    Spacer()
                    let checked = items.filter { $0.isChecked }.count
                    Text("\(checked)/\(items.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Packing Item Row
struct PackingItemRow: View {
    let item: PackingItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(item.isChecked ? .green : Color(UIColor.tertiaryLabel))
                    .animation(.spring(response: 0.2), value: item.isChecked)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(item.name)
                            .font(.body)
                            .foregroundStyle(item.isChecked ? .secondary : .primary)
                            .strikethrough(item.isChecked)

                        if item.isEssential && !item.isChecked {
                            Text("PENTING")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.12))
                                .clipShape(Capsule())
                        }

                        if item.isSpecific && !item.isChecked {
                            Text("SPESIFIK")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(.purple)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.purple.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    if item.quantity > 1 {
                        Text("Qty: \(item.quantity)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Add Item Sheet
struct AddItemSheet: View {
    let category: PackingCategory
    @ObservedObject var vm: PackingListViewModel
    @State private var name: String = ""
    @State private var isEssential: Bool = false
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Detail Item") {
                    TextField("Nama item...", text: $name)
                        .focused($focused)
                    Toggle("Tandai sebagai penting", isOn: $isEssential)
                }
                Section {
                    Button("Tambahkan") {
                        vm.addItem(name: name, category: category, isEssential: isEssential)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Tambah ke \(category.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
            }
            .onAppear { focused = true }
        }
        .presentationDetents([.medium])
    }
}

extension PackingCategory: Identifiable {
    public var id: String { rawValue }
}