//
//  EditItemTagSheet.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//


import SwiftUI

struct EditItemTagSheet: View {
    let item: PackingItem
    let onOwnershipChange: (ItemOwnership) -> Void
    let onEssentialChange: (Bool) -> Void

    @State private var selectedOwnership: ItemOwnership
    @State private var isEssential: Bool
    @Environment(\.dismiss) private var dismiss

    init(
        item: PackingItem,
        onOwnershipChange: @escaping (ItemOwnership) -> Void,
        onEssentialChange: @escaping (Bool) -> Void
    ) {
        self.item               = item
        self.onOwnershipChange  = onOwnershipChange
        self.onEssentialChange  = onEssentialChange
        _selectedOwnership      = State(initialValue: item.ownership)
        _isEssential            = State(initialValue: item.isEssential)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: - Item Header
                VStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.blue)
                        .padding(16)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())

                    Text(item.name)
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)

                    // Preview hierarki saat ini
                    priorityBadge
                }
                .padding(.vertical, 20)

                Divider()

                // MARK: - Form
                Form {
                    // Ownership section
                    Section {
                        ForEach(ItemOwnership.allCases, id: \.self) { ownership in
                            Button {
                                withAnimation(.spring(response: 0.25)) {
                                    selectedOwnership = ownership
                                }
                            } label: {
                                HStack(spacing: 14) {
                                    // Ikon
                                    Image(systemName: ownership.sfSymbol)
                                        .font(.system(size: 15))
                                        .foregroundStyle(ownershipColor(ownership))
                                        .frame(width: 36, height: 36)
                                        .background(ownershipColor(ownership).opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    // Label + deskripsi
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ownership.rawValue)
                                            .font(.system(size: 16))
                                            .foregroundStyle(Color.primary)
                                        Text(ownershipDescription(ownership))
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.secondary)
                                    }

                                    Spacer()

                                    // Checkmark
                                    if selectedOwnership == ownership {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(ownershipColor(ownership))
                                            .font(.system(size: 20))
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Kepemilikan Barang")
                    }

                    // Penting section
                    Section {
                        Toggle(isOn: $isEssential) {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                    .frame(width: 36, height: 36)
                                    .background(Color.orange.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Tandai Penting")
                                        .font(.system(size: 16))
                                    Text("Item wajib dibawa, tidak boleh ketinggalan")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .tint(.orange)
                    } header: {
                        Text("Prioritas")
                    }
                }
            }
            .navigationTitle("Edit Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        onOwnershipChange(selectedOwnership)
                        onEssentialChange(isEssential)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Priority Badge
    private var priorityBadge: some View {
        let (label, color) = priorityInfo(isEssential: isEssential, ownership: selectedOwnership)
        return Text(label)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
            .animation(.spring(response: 0.3), value: selectedOwnership)
            .animation(.spring(response: 0.3), value: isEssential)
    }

    private func priorityInfo(isEssential: Bool, ownership: ItemOwnership) -> (String, Color) {
        switch (isEssential, ownership) {
        case (true, .sewa):    return ("⚡ Penting · Sewa", .red)
        case (true, .bersama): return ("⚡ Penting · Bersama", .orange)
        case (true, .pribadi): return ("⚡ Penting · Pribadi", .orange)
        case (false, .sewa):   return ("🛒 Sewa", .orange)
        case (false, .bersama):return ("👥 Bersama", .green)
        case (false, .pribadi):return ("👤 Pribadi", .blue)
        }
    }

    private func ownershipDescription(_ ownership: ItemOwnership) -> String {
        switch ownership {
        case .pribadi: return "Barang milik sendiri"
        case .bersama: return "Dibagi / ditanggung bersama"
        case .sewa:    return "Perlu disewa sebelum berangkat"
        }
    }

    private func ownershipColor(_ ownership: ItemOwnership) -> Color {
        switch ownership {
        case .pribadi: return .blue
        case .bersama: return .green
        case .sewa:    return .orange
        }
    }
}

