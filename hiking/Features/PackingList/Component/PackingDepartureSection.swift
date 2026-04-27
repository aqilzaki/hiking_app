//
//  PackingDepartureSection.swift
//  hiking
//
//  Created by muhammad aqil zaki on 27/04/26.
//


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