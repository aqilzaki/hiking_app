//
//  FilterRow.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//


import SwiftUI

struct FilterRow: View {
    @ObservedObject var vm: PackingListViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(
                    label: "Semua",
                    isSelected: !vm.showEssentialOnly && vm.ownershipFilter == nil
                ) {
                    vm.showEssentialOnly = false
                    vm.ownershipFilter   = nil
                }
                FilterPill(label: "⭐ Esensial", isSelected: vm.showEssentialOnly, color: .orange) {
                    vm.showEssentialOnly = true
                    vm.ownershipFilter   = nil
                }
                FilterPill(label: "👤 Pribadi", isSelected: vm.ownershipFilter == .pribadi, color: .blue) {
                    vm.ownershipFilter   = vm.ownershipFilter == .pribadi ? nil : .pribadi
                    vm.showEssentialOnly = false
                }
                FilterPill(label: "👥 Bersama", isSelected: vm.ownershipFilter == .bersama, color: .green) {
                    vm.ownershipFilter   = vm.ownershipFilter == .bersama ? nil : .bersama
                    vm.showEssentialOnly = false
                }
                FilterPill(label: "🛒 Sewa", isSelected: vm.ownershipFilter == .sewa, color: .orange) {
                    vm.ownershipFilter   = vm.ownershipFilter == .sewa ? nil : .sewa
                    vm.showEssentialOnly = false
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}