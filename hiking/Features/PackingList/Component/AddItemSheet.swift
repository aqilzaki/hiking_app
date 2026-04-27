//
//  AddItemSheet.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//


import SwiftUI

struct AddItemSheet: View {
    let category: PackingCategory
    @ObservedObject var vm: PackingListViewModel
    @State private var name: String            = ""
    @State private var isEssential: Bool       = false
    @State private var ownership: ItemOwnership = .pribadi
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Detail Item") {
                    TextField("Nama item...", text: $name)
                        .focused($focused)
                    Toggle("Tandai sebagai penting", isOn: $isEssential)
                    Picker("Jenis", selection: $ownership) {
                        ForEach(ItemOwnership.allCases, id: \.self) { o in
                            Label(o.rawValue, systemImage: o.sfSymbol).tag(o)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Button("Tambahkan") {
                        vm.addItem(name: name, category: category,
                                   isEssential: isEssential, ownership: ownership)
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


