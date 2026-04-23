//  PackingRecommendation.swift
//  hiking

import Foundation

struct PackingRecommendation {

    static func generate(mountain: Mountain, config: TripConfig) -> [PackingItem] {
        var items: [PackingItem] = []

        // MARK: - 1. Shelter
        items += [
            item("Sleeping bag",        .shelter, essential: true,  ownership: .pribadi,  rentable: true),
            item("Matras / sleeping pad",.shelter, essential: true,  ownership: .pribadi,  rentable: true),
            item("Pasak",               .shelter, essential: true,  ownership: .bersama),
            item("Rangka tenda",        .shelter, essential: true,  ownership: .bersama,  rentable: true),
            item("Flysheet",            .shelter, essential: true,  ownership: .bersama,  rentable: true),
            item("Tenda",               .shelter, essential: true,  ownership: .bersama,  rentable: true),
            item("Tali tenda",          .shelter, essential: true,  ownership: .bersama),
            item("Hammock",             .shelter, essential: false, ownership: .pribadi,  rentable: true),
        ]

        // MARK: - 2. Barang Pribadi
        items += [
            item("Sepatu gunung",       .pakaian, essential: true,  ownership: .pribadi,  rentable: true),
            item("Kaos kaki",           .pakaian, essential: true,  ownership: .pribadi,  qty: 3),
            item("Jaket gunung",        .pakaian, essential: true,  ownership: .pribadi,  rentable: true),
            item("Pakaian ganti",       .pakaian, essential: true,  ownership: .pribadi),
            item("Sarung tangan",       .pakaian, essential: true,  ownership: .pribadi,  rentable: true),
            item("KTP",                 .dokumen, essential: true,  ownership: .pribadi),
            item("Surat izin pendakian",.dokumen, essential: false, ownership: .bersama),
            item("Sandal camp",         .pakaian, essential: false, ownership: .pribadi),
            item("Masker",              .pakaian, essential: false, ownership: .pribadi),
            item("Topi",                .pakaian, essential: false, ownership: .pribadi),
            item("Sunblock / sunscreen",.pakaian, essential: false, ownership: .pribadi),
            item("Alat mandi",          .pakaian, essential: false, ownership: .pribadi),
        ]

        // MARK: - 3. Logistik
        items += [
            item("Makanan berat",           .makanan, essential: true,  ownership: .bersama),
            item("Makanan ringan / snack",  .makanan, essential: true,  ownership: .pribadi),
            item("Nesting / cooking system",.cooking, essential: true,  ownership: .bersama, rentable: true),
            item("Piring",                  .cooking, essential: true,  ownership: .pribadi, qty: config.numberOfPeople),
            item("Sendok",                  .cooking, essential: true,  ownership: .pribadi, qty: config.numberOfPeople),
            item("Filter air",              .cooking, essential: false, ownership: .bersama, rentable: true),
        ]

        // MARK: - 4. Safety Tools
        items += [
            item("Headlamp",     .navigasi, essential: true,  ownership: .pribadi,  rentable: true),
            item("Tali prusik",  .navigasi, essential: true,  ownership: .bersama),
            item("Pisau lipat",  .navigasi, essential: true,  ownership: .bersama),
            item("Alat jahit",   .navigasi, essential: false, ownership: .bersama),
            item("Lakban",       .navigasi, essential: false, ownership: .bersama),
            item("Kompas",       .navigasi, essential: false, ownership: .bersama,  rentable: true),
            item("Peta jalur",   .navigasi, essential: false, ownership: .bersama),
            item("Trekking pole",.navigasi, essential: false, ownership: .pribadi,  rentable: true),
        ]

        // MARK: - 5. P3K
        items += [
            item("Betadine",            .p3k, essential: true, ownership: .bersama),
            item("Kapas",               .p3k, essential: true, ownership: .bersama),
            item("Kain kassa",          .p3k, essential: true, ownership: .bersama),
            item("Perban",              .p3k, essential: true, ownership: .bersama),
            item("Hansaplast",          .p3k, essential: true, ownership: .bersama),
            item("Rivanol",             .p3k, essential: true, ownership: .bersama),
            item("Obat alergi (CTM)",   .p3k, essential: true, ownership: .bersama),
            item("Obat maag",           .p3k, essential: true, ownership: .bersama),
            item("Parasetamol",         .p3k, essential: true, ownership: .bersama),
            item("Obat diare",          .p3k, essential: true, ownership: .bersama),
            item("Obat keracunan (Norit)",.p3k, essential: true, ownership: .bersama),
            item("Oralit",              .p3k, essential: true, ownership: .bersama),
            item("Minyak kayu putih",   .p3k, essential: true, ownership: .bersama),
            item("Salep memar",         .p3k, essential: true, ownership: .bersama),
            item("Obat tetes mata",     .p3k, essential: true, ownership: .bersama),
        ]

        // MARK: - 6. Lainnya
        items += [
            item("Trash bag",      .navigasi, essential: true, ownership: .bersama, qty: 2),
            item("Rain cover tas", .navigasi, essential: true, ownership: .pribadi),
        ]

        // MARK: - 7. Spesifik Gunung
        for specialItem in mountain.specialItems {
            items.append(PackingItem(
                name: specialItem,
                isEssential: true,
                category: .spesifik,
                isSpecific: true,
                ownership: .pribadi
            ))
        }

        return items
    }

    // MARK: - Helper
    private static func item(
        _ name: String,
        _ category: PackingCategory,
        essential: Bool,
        ownership: ItemOwnership = .pribadi,
        rentable: Bool = false,
        qty: Int = 1
    ) -> PackingItem {
        PackingItem(
            name: name,
            isEssential: essential,
            category: category,
            isSpecific: false,
            quantity: max(1, qty),
            ownership: ownership,
            isRentable: rentable
        )
    }
}
