//
//  MountainDetailViewModel.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI

final class MountainDetailViewModel: ObservableObject {
    let mountain: Mountain

    @Published var numberOfPeople: Int = 2
    @Published var durationDays: Int

    init(mountain: Mountain) {
        self.mountain = mountain
        self.durationDays = mountain.durationDays.lowerBound
    }

    var minDays: Int { mountain.durationDays.lowerBound }
    var maxDays: Int { mountain.durationDays.upperBound }

    func buildTrip() -> Trip {
        let items = PackingListService.generate(
            for: mountain,
            people: numberOfPeople,
            days: durationDays
        )
        return Trip(
            mountainId: mountain.id,
            mountainName: mountain.name,
            mountainProvince: mountain.province,
            grade: mountain.grade,
            numberOfPeople: numberOfPeople,
            durationDays: durationDays,
            items: items
        )
    }
}