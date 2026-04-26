//
//  HikingChecklistView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 16/04/26.
//


// HikingChecklistView.swift

import SwiftUI

struct HikingChecklistView: View {
    @StateObject private var vm: PackingListViewModel

    init(trip: Trip) {
        _vm = StateObject(wrappedValue: PackingListViewModel(trip: trip))
    }

    var body: some View {
        List {
            ForEach(vm.displayedCategories, id: \.self) { category in
                let items = vm.filteredItems(for: category)
                if !items.isEmpty {
                    Section {
                        ForEach(items) { item in
                            HStack {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isChecked ? .green : .secondary)
                                Text(item.name)
                                    .strikethrough(item.isChecked, color: .secondary)
                                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                                if item.isEssential {
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.orange)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.toggle(itemId: item.id)
                            }
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.sfSymbol)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Double Cek")
        .navigationBarTitleDisplayMode(.large)
    }
}
