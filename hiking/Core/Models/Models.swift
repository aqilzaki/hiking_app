import Foundation

// MARK: - Grade
enum Grade: String, Codable, CaseIterable, Hashable {
    case i    = "Grade I"
    case ii   = "Grade II"
    case iii  = "Grade III"
    case iv   = "Grade IV"
    case v    = "Grade V"
    
    var label: String { rawValue }

    var color: String {
        switch self {
        case .i:   return "gradeI"
        case .ii:  return "gradeII"
        case .iii: return "gradeIII"
        case .iv:  return "gradeIV"
        case .v:   return "gradeV"
        }
    }

    var sortOrder: Int {
        switch self { case .i: return 1; case .ii: return 2; case .iii: return 3; case .iv: return 4; case .v: return 5 }
    }

    var difficultyLabel: String {
        switch self {
        case .i:   return "Sangat Mudah"
        case .ii:  return "Mudah"
        case .iii: return "Menengah"
        case .iv:  return "Sulit"
        case .v:   return "Ekstrem"
        }
    }

    var sfSymbol: String {
        switch self {
        case .i:   return "1.circle.fill"
        case .ii:  return "2.circle.fill"
        case .iii: return "3.circle.fill"
        case .iv:  return "4.circle.fill"
        case .v:   return "5.circle.fill"
        }
    }
    
}

// MARK: - Mountain
struct Mountain: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageName : String
    let province: String
    let grade: Grade
    let gradeNote: String          // e.g. "Grade II & III"
    let durationNote: String       // e.g. "2 Hari 1 Malam"
    let durationDays: ClosedRange<Int>
    let specialItems: [String]
    let reference: String
    let isCurrentlyClosed: Bool
    let closureNote: String
    let altitude: Int?             // meter, optional

    // Hashable conformance
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Mountain, rhs: Mountain) -> Bool { lhs.id == rhs.id }
}

// MARK: - PackingItem
struct PackingItem: Identifiable, Codable , Hashable {
    var id: UUID = UUID()
    var name: String
    var isChecked: Bool = false
    var isEssential: Bool
    var category: PackingCategory
    var isSpecific: Bool = false   // mountain-specific item
    var quantity: Int = 1
    var ownership: ItemOwnership = .pribadi  
    var isRentable: Bool = false
}

// MARK: - PackingCategory
enum PackingCategory: String, Codable, CaseIterable {
    case pakaian      = "Pakaian"
    case shelter      = "Shelter"
    case sleeping     = "Sleeping System"
    case cooking      = "Cooking System"
    case navigasi     = "Navigasi & Tools"
    case p3k          = "P3K & Kesehatan"
    case dokumen      = "Dokumen & Admin"
    case makanan      = "Makanan & Air"
    case spesifik     = "Spesifik Gunung Ini"

    
    var sfSymbol: String {
        switch self {
        case .pakaian:   return "tshirt.fill"
        case .shelter:   return "tent.fill"
        case .sleeping:  return "bed.double.fill"
        case .cooking:   return "flame.fill"
        case .navigasi:  return "location.north.fill"
        case .p3k:       return "cross.case.fill"
        case .dokumen:   return "doc.fill"
        case .makanan:   return "fork.knife"
        case .spesifik:  return "star.fill"
        }
    }
}

// MARK: - Trip (saved history)
struct Trip: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var mountainId: String
    var mountainName: String
    var mountainProvince: String
    var grade: Grade
    var numberOfPeople: Int
    var durationDays: Int
    var items: [PackingItem]
    var createdAt: Date = Date()
    var completedAt: Date?

    var checkedCount: Int { items.filter { $0.isChecked }.count }
    var totalCount: Int { items.count }
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(checkedCount) / Double(totalCount)
    }
    var isCompleted: Bool { progress >= 1.0 }

    var groupedItems: [PackingCategory: [PackingItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
}


