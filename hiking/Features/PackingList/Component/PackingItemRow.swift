import SwiftUI

struct PackingItemRow: View {
    let item: PackingItem
    let onToggle: () -> Void
    let onOwnershipChange: (ItemOwnership) -> Void
    let onEssentialChange: (Bool) -> Void

    @State private var showEditSheet = false

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                // Checkbox
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(item.isChecked ? Color.green : Color(UIColor.tertiaryLabel))
                    .animation(.spring(response: 0.2), value: item.isChecked)

                VStack(alignment: .leading, spacing: 4) {
                    // Nama + badges
                    HStack(spacing: 6) {
                        Text(item.name)
                            .font(.body)
                            .foregroundStyle(item.isChecked ? Color.secondary : Color.primary)
                            .strikethrough(item.isChecked)

                        if item.isEssential && !item.isChecked {
                            badgeView("PENTING", color: .orange)
                        }
                        if item.isSpecific && !item.isChecked {
                            badgeView("SPESIFIK", color: .purple)
                        }
                    }

                    // Ownership badge
                    HStack(spacing: 6) {
                        ownershipBadgeView(item.ownership, isRentable: item.isRentable)
                        if item.quantity > 1 {
                            Text("Qty: \(item.quantity)")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                Spacer()

                // Ikon ownership kanan
                Image(systemName: item.ownership.sfSymbol)
                    .font(.system(size: 13))
                    .foregroundStyle(ownershipColor(item.ownership).opacity(0.5))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // Swipe kiri → edit tag
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                showEditSheet = true
            } label: {
                Label("Edit Tag", systemImage: "tag.fill")
            }
            .tint(.blue)
        }
        .sheet(isPresented: $showEditSheet) {
            EditItemTagSheet(
                item: item,
                onOwnershipChange: onOwnershipChange,
                onEssentialChange: onEssentialChange
            )
        }
    }

    private func badgeView(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .black))
            .foregroundStyle(color)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    private func ownershipBadgeView(_ ownership: ItemOwnership, isRentable: Bool) -> some View {
        HStack(spacing: 3) {
            Image(systemName: ownership.sfSymbol).font(.system(size: 9))
            Text(isRentable && ownership != .sewa
                 ? "\(ownership.rawValue) / Sewa"
                 : ownership.rawValue)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(ownershipColor(ownership))
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(ownershipColor(ownership).opacity(0.1))
        .clipShape(Capsule())
    }

    private func ownershipColor(_ ownership: ItemOwnership) -> Color {
        switch ownership {
        case .pribadi: return .blue
        case .bersama: return .green
        case .sewa:    return .orange
        }
    }
}
