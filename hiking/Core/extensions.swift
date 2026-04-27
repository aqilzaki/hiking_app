//
//  extensions.swift
//  hiking
//
//  Created by muhammad aqil zaki on 26/04/26.
//


extension Trip {
    static var preview: Trip {
        Trip(
            mountainId: "smeru",
            mountainName: "Semeru",
            mountainProvince: "Jawa Timur",
            grade: .iii,
            numberOfPeople: 4,
            durationDays: 3,
            items: []
        )
    }
}
