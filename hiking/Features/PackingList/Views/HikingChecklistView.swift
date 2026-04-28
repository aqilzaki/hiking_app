// HikingChecklistView.swift
import SwiftUI

struct HikingChecklistView: View {
    @StateObject private var vm: JourneyChecklistViewModel

    init(trip: Trip) {
        _vm = StateObject(wrappedValue: JourneyChecklistViewModel(trip: trip))
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Terkumpul")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(vm.checkedCount)/\(vm.totalCount)")
                        .font(.caption.bold())
                    ProgressView(value: vm.progress)
                        .tint(vm.progress >= 1.0 ? .green : .blue)
                        .frame(width: 80)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

            ForEach(vm.categories, id: \.self) { category in
                let items = vm.items(for: category)
                if !items.isEmpty {
                    Section {
                        ForEach(items) { item in
                            HStack(spacing: 10) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 16))
                                    .foregroundStyle(item.isChecked ? .green : Color(.systemGray3))
                                    .animation(.spring(response: 0.2), value: item.isChecked)

                                Text(item.name)
                                    .font(.system(size: 14))
                                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                                    .strikethrough(item.isChecked, color: .secondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { vm.toggle(itemId: item.id) }
                            .padding(.vertical, 1)
                        }
                    } header: {
                        HStack(spacing: 4) {
                            Image(systemName: category.sfSymbol)
                                .font(.caption2)
                            Text(category.rawValue)
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .environment(\.defaultMinListRowHeight, 36)
    }
}
