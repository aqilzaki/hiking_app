//
//  MountainListViewModel.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI
import Combine

final class MountainListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedGrade: Grade? = nil

    var mountains: [Mountain] {
        MountainDatabase.filtered(grade: selectedGrade, query: searchText)
    }

    var gradeGroups: [(Grade, [Mountain])] {
        let grades: [Grade] = selectedGrade.map { [$0] } ?? Grade.allCases
        return grades.compactMap { grade in
            let ms = mountains.filter { $0.grade == grade }
            return ms.isEmpty ? nil : (grade, ms)
        }
    }

    func clearFilters() {
        searchText = ""
        selectedGrade = nil
    }
}