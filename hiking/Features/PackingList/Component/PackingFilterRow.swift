//
//  PackingFilterRow.swift
//  hiking
//
//  Created by muhammad aqil zaki on 27/04/26.
//


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