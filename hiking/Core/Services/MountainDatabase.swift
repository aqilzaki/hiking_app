//
//  MountainDatabase.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import Foundation

struct MountainDatabase {
    static let all: [Mountain] = [
        // GRADE I
        Mountain(name:"Gunung Bromo",province:"Jawa Timur",grade:.I,durationDays:1...1,durationNote:"Tektok",specificItems:["Masker tebal / buff (sangat berdebu, pasir berterbangan)","Kacamata anti debu / goggles","Jaket tebal (angin & dingin subuh)"],reference:"TNBTS",isActive:true),
        // GRADE II
        Mountain(name:"Gunung Ambang",province:"Sulawesi Utara",grade:.II,durationDays:1...2,specificItems:["Masker gas / kain (bau belerang cukup menyengat di area kawah)"],reference:"BKSDA Sulawesi Utara",isActive:true),
        Mountain(name:"Gunung Ijen",province:"Jawa Timur",grade:.II,durationDays:1...1,durationNote:"Tektok",specificItems:["Masker Respirator / Gas (wajib untuk turun ke area blue fire)","Headlamp (pendakian dini hari)"],reference:"BKSDA Jawa Timur",isActive:true),
        Mountain(name:"Gunung Kaba",province:"Bengkulu",grade:.II,durationDays:1...2,specificItems:["Senter kepala (headlamp) ekstra untuk night trekking ke kawah"],reference:"BKSDA Bengkulu",isActive:true),
        Mountain(name:"Gunung Merapi",province:"Jawa Tengah",grade:.II,durationDays:2...1,specificItems:["Helm pendakian (wajib pelindung kepala dari batuan lepas di area Pasar Bubrah)","Masker tebal / respirator"],reference:"TNGM",isClosed:true,isActive:true,warningNote:"Saat ini jalur pendakian ditutup permanen"),
        Mountain(name:"Gunung Bulubaria",province:"Sulawesi Selatan",grade:.II,durationDays:2...1,specificItems:["Sepatu / sandal bersol kasar (jalur tanah licin khas hutan hujan)"],reference:"APGI Sulsel"),
        Mountain(name:"Gunung Tambora",province:"NTB",grade:.II,durationDays:3...4,specificItems:["Gaiter (jalur berdebu tebal)","Masker (pasir vulkanik di bibir kaldera)"],reference:"Taman Nasional Gunung Tambora",isActive:true),
        Mountain(name:"Gunung Mambulilling",province:"Sulawesi Barat",grade:.II,durationDays:5...7,durationNote:"Realita",specificItems:["Parang / golok (jalur perintis / tertutup)","Obat anti-malaria","Logistik jangka panjang"],reference:"Catatan Ekspedisi Mapala se-Sulawesi"),
        Mountain(name:"Gunung Kelimutu",province:"NTT",grade:.II,durationDays:1...1,durationNote:"Tektok",specificItems:["Jaket penahan angin (tektok subuh untuk sunrise, cukup dingin)"],reference:"Taman Nasional Kelimutu"),
        Mountain(name:"Gunung Papandayan",province:"Jawa Barat",grade:.II,durationDays:2...1,specificItems:["Masker belerang","Trash bag (pengelolaan sampah sangat ketat)"],reference:"TWA Gunung Papandayan / PT AIL",isActive:true),
        Mountain(name:"Gunung Bulusaraung",province:"Sulawesi Selatan",grade:.II,durationDays:2...1,specificItems:["Sepatu trekking anti-slip (banyak jalur batuan karst yang tajam dan licin)"],reference:"Taman Nasional Bantimurung Bulusaraung"),
        Mountain(name:"Gunung Batur",province:"Bali",grade:.II,durationDays:1...1,durationNote:"Tektok",specificItems:["Trekking pole","Headlamp (pendakian umumnya dimulai jam 2–3 pagi)"],reference:"BKSDA Bali / Asosiasi Pemandu Batur",isActive:true),
        Mountain(name:"Gunung Maras",province:"Bangka Belitung",grade:.II,durationDays:1...2,specificItems:["Water bladder / jerigen air (sumber air sangat minim / sulit di atas gunung)"],reference:"BKSDA Sumatera Selatan (Wilayah Babel)"),
        // GRADE III
        Mountain(name:"Gunung Ciremai",province:"Jawa Barat",grade:.III,durationDays:2...3,specificItems:["Water bladder ekstra (tidak ada sumber air di jalur Apuy / Palutungan / Linggarjati)"],reference:"TNGC (Taman Nasional Gunung Ciremai)"),
        Mountain(name:"Gunung Bawakaraeng",province:"Sulawesi Selatan",grade:.III,durationDays:2...3,specificItems:["Jaket thermal tebal (suhu puncaknya terkenal sangat ekstrem di waktu tertentu)"],reference:"Basarnas Sulsel / Catatan Mapala Makassar"),
        Mountain(name:"Gunung Pangrango",province:"Jawa Barat",grade:.III,durationDays:2...1,specificItems:["Pakaian tebal","Jas hujan (suhu sangat dingin dan lembap di Lembah Mandalawangi)"],reference:"TNGGP (Taman Nasional Gede Pangrango)"),
        Mountain(name:"Gunung Gede",province:"Jawa Barat",grade:.III,durationDays:2...1,specificItems:["Print out SIMAKSI & surat sehat asli (wajib untuk pengecekan pos masuk)"],reference:"TNGGP (Taman Nasional Gede Pangrango)",isActive:true),
        Mountain(name:"Gunung Halimun Salak",province:"Jawa Barat",grade:.III,durationDays:2...3,specificItems:["Jaket panjang","Jas hujan (hutan hujan sangat rapat, basah, dan banyak lintah / pacet)"],reference:"TNGHS"),
        Mountain(name:"Gunung Merbabu",province:"Jawa Tengah",grade:.III,durationDays:2...1,specificItems:["Botol / jerigen air ekstra (sangat minim sumber air, terutama via Selo)"],reference:"TNGMb (Taman Nasional Gunung Merbabu)"),
        Mountain(name:"Gunung Nokilalaki",province:"Sulawesi Tengah",grade:.III,durationDays:2...1,specificItems:["Pakaian berlengan panjang & gaiter (banyak tumbuhan berduri rotan dan lintah)"],reference:"Taman Nasional Lore Lindu"),
        Mountain(name:"Gunung Masurai",province:"Jambi",grade:.III,durationDays:3...4,specificItems:["Jas hujan mumpuni","Pakaian quick dry (hutan hujan tropis Sumatera yang pekat dan basah)"],reference:"TNKS"),
        Mountain(name:"Gunung Tujuh",province:"Kerinci / Jambi",grade:.III,durationDays:1...2,specificItems:["Jaket windbreaker (berada di pinggir danau kaldera tertinggi, angin sangat kencang)"],reference:"TNKS"),
        Mountain(name:"Gunung Kerinci",province:"Jambi",grade:.III,durationDays:2...3,specificItems:["Gaiter anti lintah","Jas hujan heavy duty","Helm (jalur menuju puncak sering ada badai / batu lepas)"],reference:"TNKS",isActive:true),
        Mountain(name:"Gunung Singgalang",province:"Sumatera Barat",grade:.III,durationDays:2...1,specificItems:["Jas hujan & baju hangat ekstra (sering hujan, kawasan Telaga Dewi sangat dingin / lembap)"],reference:"BKSDA Sumatera Barat"),
        Mountain(name:"Gunung Marapi",province:"Sumatera Barat",grade:.III,durationDays:2...1,specificItems:["Masker tebal / respirator (gunung berapi sangat aktif, banyak gas beracun / abu)"],reference:"BKSDA Sumatera Barat",isActive:true,warningNote:"Saat ini sering fluktuatif / ditutup, cek status terbaru sebelum mendaki"),
        // GRADE IV
        Mountain(name:"Gunung Argopuro",province:"Jawa Timur",grade:.IV,durationDays:4...5,specificItems:["Tas carrier kapasitas besar & logistik ekstra (trek terpanjang di Pulau Jawa)"],reference:"BKSDA Jawa Timur"),
        Mountain(name:"Bukit Raya",province:"Kalimantan Tengah",grade:.IV,durationDays:5...7,specificItems:["Sepatu boot karet / kets kuat & gaiter (jalur berlumpur ekstrem dan banyak pacet)"],reference:"Taman Nasional Bukit Baka Bukit Raya"),
        Mountain(name:"Gandang Dewata",province:"Sulawesi Barat",grade:.IV,durationDays:7...10,specificItems:["Obat anti-malaria","Peralatan survival","Tali webbing (ekspedisi perintis yang sangat rimbun)"],reference:"Taman Nasional Gandang Dewata"),
        Mountain(name:"Gunung Semeru",province:"Jawa Timur",grade:.IV,durationDays:3...4,specificItems:["Masker tebal","Helm","Kacamata goggles (penahan debu vulkanik / batu lepas di Tanjakan Cinta – Mahameru)"],reference:"TNBTS",isActive:true),
        Mountain(name:"Gunung Binaiya",province:"Maluku",grade:.IV,durationDays:6...8,specificItems:["Sandal gunung kuat / sepatu amfibi (harus menyeberangi Sungai Yahe dan Kobi yang lebar)"],reference:"Taman Nasional Manusela / APGI Maluku"),
        Mountain(name:"Gunung Rinjani",province:"NTB",grade:.IV,durationDays:3...4,specificItems:["Trekking pole & gaiter (sangat membantu untuk melibas pasir tebal di jalur summit attack)"],reference:"TNGR (Taman Nasional Gunung Rinjani)",isActive:true),
        // GRADE V
        Mountain(name:"Gunung Leuser",province:"Aceh",grade:.V,durationDays:10...14,specificItems:["Logistik lengkap","Golok tebas","Sepatu boot karet","Obat-obatan hutan tropis & lintah"],reference:"Taman Nasional Gunung Leuser (TNGL)"),
        Mountain(name:"Carstensz Pyramid",province:"Papua",grade:.V,durationDays:10...14,specificItems:["Harness","Jumar / ascender","Figure 8 / descender","Carabiner (min. 3 buah)","Helm panjat","Crampon (alat panjat tebing bersalju standar internasional)"],reference:"Operator Ekspedisi Internasional / Taman Nasional Lorentz"),
        Mountain(name:"Gunung Trikora",province:"Papua",grade:.V,durationDays:7...10,specificItems:["Peralatan panjat tebing Alpine","Jaket bulang (down jacket) tebal (suhu membeku di pegunungan Jayawijaya)"],reference:"Operator Ekspedisi / Catatan Ekspedisi Mapala"),
    ]
}