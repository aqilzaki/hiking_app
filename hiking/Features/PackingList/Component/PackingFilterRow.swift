// PackingFilterRow.swift
import SwiftUI

struct PackingFilterRow: View {
    @ObservedObject var vm: PackingListViewModel

    var body: some View {
        FilterRow(vm: vm)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}