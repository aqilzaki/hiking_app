// PackingToolbar.swift
import SwiftUI

struct PackingToolbar: ToolbarContent {
    let vm: PackingListViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button { vm.checkAllItems() } label: {
                    Label("Centang Semua", systemImage: "checkmark.circle.fill")
                }
                Button { vm.uncheckAllItems() } label: {
                    Label("Hapus Semua Centang", systemImage: "circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}