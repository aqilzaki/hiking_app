//  PackingRecommendation.swift
//  hiking

import Foundation

struct PackingRecommendation {

    static func generate(mountain: Mountain, config: TripConfig) -> [PackingItem] {
        var items: [PackingItem] = []

        // MARK: - Pakaian (selalu ada)
        items += [
            item("Kaos lapangan", .pakaian, essential: true),
            item("Celana hiking", .pakaian, essential: true),
            item("Jaket fleece", .pakaian, essential: true),
            item("Jaket waterproof / raincoat", .pakaian, essential: true),
            item("Kaos kaki wool/tebal", .pakaian, essential: true, qty: min(config.numberOfPeople * mountain.durationDays.lowerBound, 6)),
            item("Sarung tangan", .pakaian, essential: mountain.grade.sortOrder >= 3),
            item("Kupluk / buff", .pakaian, essential: mountain.grade.sortOrder >= 3),
            item("Gaiter", .pakaian, essential: mountain.grade.sortOrder >= 4),
            item("Balaclava", .pakaian, essential: mountain.grade.sortOrder >= 4),
            item("Sepatu hiking", .pakaian, essential: true),
            item("Sandal camp", .pakaian, essential: false),
            item("Jas hujan poncho", .pakaian, essential: true),
        ]

        // MARK: - Shelter
        if config.includeSleeping {
            items += [
                item("Tenda \(config.numberOfPeople <= 2 ? "2P" : "4P")", .shelter, essential: true),
                item("Footprint / alas tenda", .shelter, essential: false),
                item("Trekking pole", .shelter, essential: mountain.grade.sortOrder >= 3),
            ]
        }

        // MARK: - Sleeping System
        if config.includeSleeping {
            let needWarmSleepingBag = mountain.grade.sortOrder >= 3
            items += [
                item("Sleeping bag \(needWarmSleepingBag ? "(suhu -5°C)" : "(suhu 10°C)")", .sleeping, essential: true),
                item("Matras / sleeping pad", .sleeping, essential: true),
                item("Liner sleeping bag", .sleeping, essential: mountain.grade.sortOrder >= 4),
            ]
        }

        // MARK: - Cooking System
        if config.includeCooking {
            items += [
                item("Kompor portable + gas", .cooking, essential: true),
                item("Nesting / panci", .cooking, essential: true),
                item("Sendok & garpu", .cooking, essential: true, qty: config.numberOfPeople),
                item("Korek api / lighter", .cooking, essential: true, qty: 2),
                item("Windshield kompor", .cooking, essential: mountain.grade.sortOrder >= 3),
                item("Botol minum", .cooking, essential: true, qty: config.numberOfPeople),
                item("Water filter / purifier", .cooking, essential: mountain.grade.sortOrder >= 3),
            ]
        }

        // MARK: - Navigasi & Tools
        items += [
            item("Headlamp + baterai cadangan", .navigasi, essential: true, qty: config.numberOfPeople),
            item("Peta jalur pendakian", .navigasi, essential: true),
            item("Kompas", .navigasi, essential: mountain.grade.sortOrder >= 3),
            item("GPS / aplikasi maps offline", .navigasi, essential: mountain.grade.sortOrder >= 3),
            item("Powerbank", .navigasi, essential: true),
            item("Peluit", .navigasi, essential: true),
            item("Trash bag", .navigasi, essential: true, qty: 2),
        ]

        // MARK: - P3K & Kesehatan
        items += [
            item("Kotak P3K lengkap", .p3k, essential: true),
            item("Obat pribadi", .p3k, essential: true),
            item("Sunscreen SPF 50+", .p3k, essential: true),
            item("Obat diare & mual", .p3k, essential: true),
            item("Plester & perban", .p3k, essential: true),
            item("Paracetamol", .p3k, essential: true),
            item("Obat altitude sickness (Diamox)", .p3k, essential: mountain.grade.sortOrder >= 4),
            item("Salep antijamur", .p3k, essential: false),
            item("Hand sanitizer", .p3k, essential: true),
        ]

        // MARK: - Dokumen & Admin
        items += [
            item("KTP / identitas diri", .dokumen, essential: true, qty: config.numberOfPeople),
            item("Surat izin pendakian (SIMAKSI)", .dokumen, essential: true),
            item("Uang tunai", .dokumen, essential: true),
            item("Asuransi / BPJS", .dokumen, essential: mountain.grade.sortOrder >= 3),
            item("Formulir registrasi pendakian", .dokumen, essential: true),
        ]

        // MARK: - Makanan & Air
        let days = mountain.durationDays.lowerBound
        items += [
            item("Nasi instan / freeze-dried meal", .makanan, essential: true, qty: config.numberOfPeople * days),
            item("Snack energi (coklat, kacang, granola)", .makanan, essential: true),
            item("Mie instan", .makanan, essential: true, qty: config.numberOfPeople * days),
            item("Suplemen elektrolit", .makanan, essential: mountain.grade.sortOrder >= 3),
            item("Air minum (1.5L/orang/hari)", .makanan, essential: true),
            item("Kopi / teh sachet", .makanan, essential: false),
        ]

        // MARK: - Spesifik Gunung
        for specialItem in mountain.specialItems {
            items.append(PackingItem(
                name: specialItem,
                isEssential: true,
                category: .spesifik,
                isSpecific: true
            ))
        }

        // Extra untuk grade tinggi
        if mountain.grade.sortOrder >= 4 {
            items += [
                item("Crampon / microspike", .spesifik, essential: true, specific: true),
                item("Tali kernmantle", .spesifik, essential: true, specific: true),
            ]
        }

        return items
    }

    // MARK: - Helper
    private static func item(
        _ name: String,
        _ category: PackingCategory,
        essential: Bool,
        qty: Int = 1,
        specific: Bool = false
    ) -> PackingItem {
        PackingItem(
            name: name,
            isEssential: essential,
            category: category,
            isSpecific: specific,
            quantity: max(1, qty)
        )
    }
}
