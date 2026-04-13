import Foundation

struct PackingListService {

    static func generate(for mountain: Mountain, config: TripConfig) -> [PackingCategory] {
        let grade    = mountain.grade.order
        let days     = max(mountain.durationDays.upperBound, 1)
        let people   = config.numberOfPeople
        let pack     = config.packSize

        var cats: [PackingCategory] = []

        // 1. Wajib Spesifik dari research
        cats.append(specificCategory(mountain: mountain))

        // 2. Pakaian
        cats.append(clothingCategory(grade: grade, days: days, pack: pack))

        // 3. Navigasi & Keselamatan
        cats.append(navigationCategory(grade: grade, pack: pack))

        // 4. Sleeping (multi-hari)
        if days > 1 { cats.append(sleepingCategory(grade: grade, people: people, pack: pack)) }

        // 5. Cooking System (multi-hari)
        if days > 1 { cats.append(cookingCategory(days: days, people: people, pack: pack)) }

        // 6. Hidrasi
        cats.append(hydrationCategory(mountain: mountain, pack: pack))

        // 7. P3K
        cats.append(medicalCategory(grade: grade, isActive: mountain.isActive, pack: pack))

        // 8. Teknis (Grade IV+)
        if grade >= 4 || pack == .lengkap {
            cats.append(technicalCategory(mountain: mountain))
        }

        // 9. Administrasi
        cats.append(adminCategory(mountain: mountain))

        return cats
    }

    private static func specificCategory(mountain: Mountain) -> PackingCategory {
        PackingCategory(
            name: "Wajib Khusus – \(mountain.name.replacingOccurrences(of: "Gunung ", with: ""))",
            sfSymbol: "star.circle.fill",
            items: mountain.specificItems.map { PackingItem(name: $0, isEssential: true) }
        )
    }

    private static func clothingCategory(grade: Int, days: Int, pack: PackSize) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Kaos (\(min(days+1, 5)) lembar)", isEssential: true, quantity: min(days+1,5)),
            PackingItem(name: "Celana trekking", isEssential: true, quantity: days > 3 ? 2 : 1),
            PackingItem(name: "Pakaian dalam", isEssential: true, quantity: min(days,4)),
            PackingItem(name: "Kaos kaki wool / tebal", isEssential: true, quantity: min(days,4)),
            PackingItem(name: "Sepatu hiking / trekking", isEssential: true),
            PackingItem(name: "Jas hujan / poncho", isEssential: grade >= 2),
        ]
        if grade >= 2 { items.append(PackingItem(name: "Jaket fleece / windbreaker", isEssential: true)) }
        if grade >= 3 {
            items += [
                PackingItem(name: "Pakaian hangat / thermal layer", isEssential: true),
                PackingItem(name: "Gaiter pelindung kaki", isEssential: true),
                PackingItem(name: "Sarung tangan trekking"),
                PackingItem(name: "Kupluk / beanie"),
            ]
        }
        if grade >= 4 || pack == .lengkap {
            items += [PackingItem(name: "Balaclava"), PackingItem(name: "Gaiters anti-lintah", isEssential: true)]
        }
        return PackingCategory(name: "Pakaian & Perlindungan", sfSymbol: "tshirt", items: items)
    }

    private static func navigationCategory(grade: Int, pack: PackSize) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Headlamp + baterai cadangan", isEssential: true),
            PackingItem(name: "Peluit darurat", isEssential: true),
            PackingItem(name: "Korek api / firestarter", isEssential: grade > 1),
            PackingItem(name: "Ponsel & powerbank", isEssential: true),
        ]
        if grade >= 2 { items += [PackingItem(name: "Senter cadangan"), PackingItem(name: "Kompas")] }
        if grade >= 3 {
            items += [
                PackingItem(name: "Trekking pole", isEssential: true),
                PackingItem(name: "Peta jalur (offline / print)", isEssential: true),
                PackingItem(name: "Tali paracord 10m"),
                PackingItem(name: "Pisau lipat / multitool"),
            ]
        }
        if grade >= 4 || pack == .lengkap {
            items += [PackingItem(name: "GPS tracker / HT"), PackingItem(name: "Bivak / emergency shelter", isEssential: true)]
        }
        return PackingCategory(name: "Navigasi & Keselamatan", sfSymbol: "location.north.line", items: items)
    }

    private static func sleepingCategory(grade: Int, people: Int, pack: PackSize) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Tenda (\(people) orang)", isEssential: true),
            PackingItem(name: "Sleeping bag (sesuai suhu gunung)", isEssential: true),
            PackingItem(name: "Matras / sleeping pad", isEssential: true),
        ]
        if grade >= 3 || pack == .lengkap {
            items += [PackingItem(name: "Flysheet / terpal ekstra"), PackingItem(name: "Ground sheet")]
        }
        return PackingCategory(name: "Sleeping System", sfSymbol: "bed.double", items: items)
    }

    private static func cookingCategory(days: Int, people: Int, pack: PackSize) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Kompor portable", isEssential: true),
            PackingItem(name: "Gas cartridge (\(days/2+1) kaleng)", isEssential: true, quantity: days/2+1),
            PackingItem(name: "Nesting pot / panci", isEssential: true),
            PackingItem(name: "Piring & sendok lipat (×\(people))", isEssential: true, quantity: people),
            PackingItem(name: "Logistik makanan (\(days) hari)", isEssential: true),
            PackingItem(name: "Bumbu sachet / instan"),
            PackingItem(name: "Trash bag (sampah wajib dibawa turun)", isEssential: true, quantity: 3),
        ]
        return PackingCategory(name: "Cooking System", sfSymbol: "flame", items: items)
    }

    private static func hydrationCategory(mountain: Mountain, pack: PackSize) -> PackingCategory {
        let lowWater = mountain.specificItems.contains { s in
            let l = s.lowercased()
            return l.contains("water bladder") || l.contains("jerigen") || l.contains("minim sumber air") || l.contains("minim / sulit")
        }
        var items: [PackingItem] = [
            PackingItem(name: "Botol air minum (min. 1.5L × 2)", isEssential: true, quantity: 2),
            PackingItem(name: "Tablet purifikasi air / filter", isEssential: mountain.grade.order >= 3),
        ]
        if lowWater || pack == .lengkap {
            items.insert(PackingItem(name: "Water bladder / hydration pack (min. 3L)", isEssential: true), at: 0)
            items.append(PackingItem(name: "Jerigen air cadangan 3L", isEssential: true))
        }
        return PackingCategory(name: "Hidrasi & Air", sfSymbol: "drop", items: items)
    }

    private static func medicalCategory(grade: Int, isActive: Bool, pack: PackSize) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Paracetamol / obat sakit kepala", isEssential: true),
            PackingItem(name: "Plester & kasa steril", isEssential: true),
            PackingItem(name: "Antiseptik (betadine / alkohol)", isEssential: true),
            PackingItem(name: "Obat diare / mual", isEssential: true),
            PackingItem(name: "Obat pereda otot (counterpain)"),
        ]
        if grade >= 3 {
            items += [PackingItem(name: "Obat anti-lintah / DEET", isEssential: true), PackingItem(name: "Elastic bandage")]
        }
        if grade >= 4 || pack == .lengkap {
            items += [PackingItem(name: "Obat anti-malaria", isEssential: true), PackingItem(name: "ORS / oralit", isEssential: true)]
        }
        if isActive { items.append(PackingItem(name: "Obat antiseptik mata (iritasi abu vulkanik)", isEssential: true)) }
        return PackingCategory(name: "P3K & Kesehatan", sfSymbol: "cross.case", items: items)
    }

    private static func technicalCategory(mountain: Mountain) -> PackingCategory {
        var items: [PackingItem] = [
            PackingItem(name: "Tas carrier besar (60–80L)", isEssential: true),
            PackingItem(name: "Rain cover carrier", isEssential: true),
            PackingItem(name: "Dry bag / kantong waterproof", isEssential: true),
        ]
        let needsClimbing = mountain.specificItems.contains { $0.lowercased().contains("harness") || $0.lowercased().contains("crampon") }
        if needsClimbing {
            items += [
                PackingItem(name: "Harness panjat", isEssential: true),
                PackingItem(name: "Jumar / ascender", isEssential: true),
                PackingItem(name: "Figure 8 / descender", isEssential: true),
                PackingItem(name: "Carabiner (min. 3 buah)", isEssential: true, quantity: 3),
                PackingItem(name: "Crampon", isEssential: true),
                PackingItem(name: "Helm panjat", isEssential: true),
            ]
        }
        let needsAmphib = mountain.specificItems.contains { $0.lowercased().contains("amfibi") || $0.lowercased().contains("menyeberangi") }
        if needsAmphib {
            items += [
                PackingItem(name: "Sandal gunung / sepatu amfibi (river crossing)", isEssential: true),
                PackingItem(name: "Dry bag ekstra untuk elektronik", isEssential: true),
            ]
        }
        return PackingCategory(name: "Perlengkapan Teknis", sfSymbol: "wrench.adjustable", items: items)
    }

    private static func adminCategory(mountain: Mountain) -> PackingCategory {
        let needsSimaksi = mountain.specificItems.contains { $0.lowercased().contains("simaksi") } || mountain.grade.order >= 3
        var items: [PackingItem] = [
            PackingItem(name: "KTP / identitas diri", isEssential: true),
            PackingItem(name: "Uang tunai secukupnya", isEssential: true),
            PackingItem(name: "Nomor kontak darurat (tertulis)", isEssential: true),
        ]
        if needsSimaksi {
            items.insert(PackingItem(name: "SIMAKSI / izin pendakian (print + digital)", isEssential: true), at: 0)
            items.append(PackingItem(name: "Surat keterangan sehat (asli)", isEssential: true))
        }
        items.append(PackingItem(name: "Asuransi perjalanan / BPJS aktif", isEssential: mountain.grade.order >= 3))
        return PackingCategory(name: "Administrasi & Dokumen", sfSymbol: "doc.text", items: items)
    }
}