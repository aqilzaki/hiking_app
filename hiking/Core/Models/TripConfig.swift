//
//  TripConfig.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


struct TripConfig {
    var numberOfPeople: Int
    var packSize: PackSize
    var includeCooking: Bool = true
    var includeSleeping: Bool = true
}

enum PackSize: String, Codable, Hashable {
    case ringan
    case standar
    case lengkap
}


enum ItemOwnership: String, Codable, Hashable, CaseIterable {
    case pribadi  = "Pribadi"
    case bersama  = "Bersama"
    case sewa     = "Sewa"

    var sfSymbol: String {
        switch self {
        case .pribadi: return "person.fill"
        case .bersama: return "person.2.fill"
        case .sewa:    return "cart.fill"
        }
    }

    var color: String {
        switch self {
        case .pribadi: return "blue"
        case .bersama: return "green"
        case .sewa:    return "orange"
        }
    }
}
