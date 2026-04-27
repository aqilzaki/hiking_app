// PackingDepartureSection.swift
import SwiftUI

struct PackingDepartureSection: View {
    let mountainName: String
    let onDepart: () -> Void

    var body: some View {
        DepartureButton(mountainName: mountainName, onDepart: onDepart)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}