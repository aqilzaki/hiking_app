// PackingCategoryHeader.swift
import SwiftUI

struct PackingCategoryHeader: View {
    let category: PackingCategory
    let items: [PackingItem]
    let onCheckAll: () -> Void
    let onUncheckAll: () -> Void

    var checked: Int { items.filter { $0.isChecked }.count }
    var allChecked: Bool { checked == items.count }

    var body: some View {
        HStack {
            Label(category.rawValue, systemImage: category.sfSymbol)
            Spacer()
            Button {
                allChecked ? onUncheckAll() : onCheckAll()
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