// PackingCategorySection.swift
import SwiftUI

struct PackingCategorySection: View {
    let category: PackingCategory
    let items: [PackingItem]
    let onToggle: (UUID) -> Void
    let onOwnershipChange: (UUID, ItemOwnership) -> Void
    let onEssentialChange: (UUID, Bool) -> Void
    let onDelete: (IndexSet) -> Void
    let onAdd: () -> Void
    let onCheckAll: () -> Void
    let onUncheckAll: () -> Void

    var body: some View {
        if !items.isEmpty {
            Section {
                ForEach(items) { item in
                    PackingItemRow(
                        item: item,
                        onToggle: { onToggle(item.id) },
                        onOwnershipChange: { onOwnershipChange(item.id, $0) },
                        onEssentialChange: { onEssentialChange(item.id, $0) }
                    )
                }
                .onDelete(perform: onDelete)

                Button(action: onAdd) {
                    Label("Tambah item", systemImage: "plus.circle")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            } header: {
                PackingCategoryHeader(
                    category: category,
                    items: items,
                    onCheckAll: onCheckAll,
                    onUncheckAll: onUncheckAll
                )
            }
        }
    }
}