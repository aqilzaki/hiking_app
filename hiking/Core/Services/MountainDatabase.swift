import Foundation

struct MountainDatabase {
    static let all: [Mountain] = [

        // GRADE I
        Mountain(id:"bromo", name:"Gunung Bromo", imageName:"gunung_bromo", province:"Jawa Timur", grade:.i, gradeNote:"Padang pasir vulkanik", durationNote:"1 hari", durationDays:1...1, specialItems:["Masker tebal / buff","Kacamata anti debu / goggles","Jaket tebal (angin & dingin subuh)"], reference:"TNBTS", isCurrentlyClosed:true, closureNote:"Aktivitas vulkanik", altitude:2329),

        // GRADE II
        Mountain(id:"ambang", name:"Gunung Ambang", imageName:"gunung_ambang", province:"Sulawesi Utara", grade:.ii, gradeNote:"Kawah belerang aktif", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Masker gas / kain (bau belerang cukup menyengat di area kawah)"], reference:"BKSDA Sulawesi Utara", isCurrentlyClosed:false, closureNote:"", altitude:1795),

        Mountain(id:"ijen", name:"Gunung Ijen", imageName:"gunung_ijen", province:"Jawa Timur", grade:.ii, gradeNote:"Kawah aktif blue fire", durationNote:"Tektok", durationDays:1...1, specialItems:["Masker respirator","Headlamp"], reference:"BKSDA Jawa Timur", isCurrentlyClosed:false, closureNote:"", altitude:2769),

        Mountain(id:"kaba", name:"Gunung Kaba", imageName:"gunung_kaba", province:"Bengkulu", grade:.ii, gradeNote:"Pendakian pendek ke kawah", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Headlamp"], reference:"BKSDA Bengkulu", isCurrentlyClosed:false, closureNote:"", altitude:1952),

        Mountain(id:"bulubaria", name:"Gunung Bulubaria", imageName:"gunung_bulubaria", province:"Sulawesi Selatan", grade:.ii, gradeNote:"Hutan hujan licin", durationNote:"2 hari", durationDays:2...2, specialItems:["Sepatu anti-slip"], reference:"APGI Sulsel", isCurrentlyClosed:false, closureNote:"", altitude:2730),

        Mountain(id:"mambulilling", name:"Gunung Mambulilling", imageName:"gunung_mambuliling", province:"Sulawesi Barat", grade:.ii, gradeNote:"Berlumut tebal berkabut licin", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Trekking pole"], reference:"Mapala Sulawesi", isCurrentlyClosed:false, closureNote:"", altitude:2873),

        Mountain(id:"kelimutu", name:"Gunung Kelimutu", imageName:"gunung_kelimutu", province:"NTT", grade:.ii, gradeNote:"Danau tiga warna", durationNote:"Tektok", durationDays:1...1, specialItems:["Masker (kawah belerang)"], reference:"TN Kelimutu", isCurrentlyClosed:false, closureNote:"", altitude:1639),

        Mountain(id:"papandayan", name:"Gunung Papandayan", imageName:"gunung_papandayan", province:"Jawa Barat", grade:.ii, gradeNote:"Kawah belerang", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Masker","Trash bag"], reference:"TWA Papandayan", isCurrentlyClosed:false, closureNote:"", altitude:2665),

        Mountain(id:"bulusaraung", name:"Gunung Bulusaraung", imageName:"gunung_bulusaraung", province:"Sulawesi Selatan", grade:.ii, gradeNote:"Karst tajam", durationNote:"2 hari", durationDays:2...2, specialItems:["Sepatu anti-slip"], reference:"TN Bantimurung", isCurrentlyClosed:false, closureNote:"", altitude:1353),

        Mountain(id:"batur", name:"Gunung Batur", imageName:"gunung_batur", province:"Bali", grade:.ii, gradeNote:"Sunrise trek", durationNote:"Tektok", durationDays:1...1, specialItems:["Masker (belerang)","Gaiter (medan pasir)"], reference:"BKSDA Bali", isCurrentlyClosed:false, closureNote:"", altitude:1717),

        Mountain(id:"maras", name:"Gunung Maras", imageName:"gunung_maras", province:"Bangka Belitung", grade:.ii, gradeNote:"Minim air", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Water bladder"], reference:"BKSDA Babel", isCurrentlyClosed:false, closureNote:"", altitude:699),

        // GRADE III
        Mountain(id:"ciremai", name:"Gunung Ciremai", imageName:"gunung_ciremai", province:"Jawa Barat", grade:.iii, gradeNote:"Tanpa sumber air", durationNote:"2-3 hari", durationDays:2...3, specialItems:["Water bladder","Trekking pole"], reference:"TNGC", isCurrentlyClosed:false, closureNote:"", altitude:3078),

        Mountain(id:"bawakaraeng", name:"Gunung Bawakaraeng", imageName:"gunung_bawakaraeng", province:"Sulawesi Selatan", grade:.iii, gradeNote:"Suhu ekstrem hutan lumut", durationNote:"2-3 hari", durationDays:2...3, specialItems:["Trekking pole","Sepatu trekking","Pakaian extra (hipotermia)"], reference:"Basarnas", isCurrentlyClosed:false, closureNote:"", altitude:2830),

        Mountain(id:"pangrango", name:"Gunung Pangrango", imageName:"gunung_pangrango", province:"Jawa Barat", grade:.iii, gradeNote:"Lembap dingin macan tutul", durationNote:"2 hari", durationDays:2...2, specialItems:["Sepatu trekking","Trekking pole","Pakaian extra (hipotermia)"], reference:"TNGGP", isCurrentlyClosed:false, closureNote:"", altitude:3026),

        Mountain(id:"gede", name:"Gunung Gede", imageName:"gunung_gede", province:"Jawa Barat", grade:.iii, gradeNote:"Administrasi ketat", durationNote:"2 hari", durationDays:2...2, specialItems:["Trekking pole","Sepatu trekking","Pakaian extra (hipotermia)"], reference:"TNGGP", isCurrentlyClosed:false, closureNote:"", altitude:2958),

        Mountain(id:"halimun_salak", name:"Halimun Salak", imageName:"gunung_halimunsalak", province:"Jawa Barat", grade:.iii, gradeNote:"Hutan hujan tropis rapat berkabut", durationNote:"2-3 hari", durationDays:2...3, specialItems:["Jas hujan","Sepatu anti air"], reference:"TN Gunung Halimun Salak", isCurrentlyClosed:false, closureNote:"", altitude:1929),

        Mountain(id:"merbabu", name:"Gunung Merbabu", imageName:"gunung_merbabu", province:"Jawa Tengah", grade:.iii, gradeNote:"Banyak batuan besar", durationNote:"2 hari", durationDays:2...2, specialItems:["Jaket tebal","Kupluk","Sarung tangan"], reference:"TN Gunung Merbabu", isCurrentlyClosed:false, closureNote:"", altitude:3145),

        Mountain(id:"nokilalaki", name:"Gunung Nokilalaki", imageName:"gunung_nokilalaki", province:"Sulawesi Tengah", grade:.iii, gradeNote:"Vegetasi rapat cuaca tidak menentu", durationNote:"2 hari", durationDays:2...2, specialItems:["Trekking pole","Sepatu trekking"], reference:"TN Lore Lindu", isCurrentlyClosed:false, closureNote:"", altitude:2357),

        Mountain(id:"masurai", name:"Gunung Masurai", imageName:"gunung_masurai", province:"Jambi", grade:.iii, gradeNote:"Jalur akar pohon hutan lumut ekstrem", durationNote:"3-4 hari", durationDays:3...4, specialItems:["Jas hujan","Sepatu anti air"], reference:"BKSDA Jambi", isCurrentlyClosed:false, closureNote:"", altitude:2916),

        Mountain(id:"tujuh", name:"Gunung Tujuh", imageName:"danau_gunung_tujuh_kerinci", province:"Jambi", grade:.iii, gradeNote:"Hutan hujan tropis lebat", durationNote:"1-2 hari", durationDays:1...2, specialItems:["Jas hujan","Sepatu anti air"], reference:"TN Kerinci Seblat", isCurrentlyClosed:false, closureNote:"", altitude:2732),

        Mountain(id:"kerinci", name:"Gunung Kerinci", imageName:"gunung_kerinci", province:"Jambi", grade:.iii, gradeNote:"Gunung tertinggi Sumatera", durationNote:"2-3 hari", durationDays:2...3, specialItems:["Sepatu trekking","Trekking pole","Masker","Gaiter"], reference:"TNKS", isCurrentlyClosed:false, closureNote:"", altitude:3805),

        Mountain(id:"kelam", name:"Gunung Kelam", imageName:"gunung_kelam", province:"Kalimantan Barat", grade:.iii, gradeNote:"Dinding batu curam", durationNote:"1 hari", durationDays:1...1, specialItems:["Sarung tangan / gloves"], reference:"TWA Kelam", isCurrentlyClosed:false, closureNote:"", altitude:1002),

        // GRADE IV
        Mountain(id:"argopuro", name:"Gunung Argopuro", imageName:"gunung_argopuro", province:"Jawa Timur", grade:.iv, gradeNote:"Trek terpanjang di Jawa", durationNote:"4-5 hari", durationDays:4...5, specialItems:["GPS","Water bladder","Sepatu agak lembut"], reference:"BKSDA Jawa Timur", isCurrentlyClosed:false, closureNote:"", altitude:3088),

        Mountain(id:"bukit_raya", name:"Bukit Raya", imageName:"gunung_bukit_raya", province:"Kalimantan Tengah", grade:.iv, gradeNote:"Jalur lumpur ekstrem", durationNote:"5-7 hari", durationDays:5...7, specialItems:["Sepatu waterproof","Dry bag","Raincoat"], reference:"TN Bukit Baka Bukit Raya", isCurrentlyClosed:false, closureNote:"", altitude:2278),

        Mountain(id:"gandang_dewata", name:"Gandang Dewata", imageName:"gunung_gandang_dewata", province:"Sulawesi Barat", grade:.iv, gradeNote:"Jalur sempit licin 70 derajat", durationNote:"7-10 hari", durationDays:7...10, specialItems:["Sepatu grid kuat","Trekking pole","Tali"], reference:"TN Gandang Dewata", isCurrentlyClosed:false, closureNote:"", altitude:3037),

        Mountain(id:"binaiya", name:"Gunung Binaiya", imageName:"gunung_binaiya", province:"Maluku", grade:.iv, gradeNote:"Banyak penyeberangan sungai", durationNote:"6-8 hari", durationDays:6...8, specialItems:["Sepatu trekking kuat","Helm"], reference:"TN Manusela", isCurrentlyClosed:false, closureNote:"", altitude:3027),

        Mountain(id:"rinjani", name:"Gunung Rinjani", imageName:"gunung_rinjani", province:"NTB", grade:.iv, gradeNote:"Pasir summit berat", durationNote:"3-4 hari", durationDays:3...4, specialItems:["Masker / buff","Sepatu trekking","Kacamata pelindung"], reference:"TN Rinjani", isCurrentlyClosed:false, closureNote:"", altitude:3726),

        // GRADE V
        Mountain(id:"leuser", name:"Gunung Leuser", imageName:"gunung_leuser", province:"Aceh", grade:.v, gradeNote:"Ekspedisi hutan panjang", durationNote:"10-14 hari", durationDays:10...14, specialItems:["Sepatu waterproof","Gaiter","Raincoat"], reference:"TNGL", isCurrentlyClosed:false, closureNote:"", altitude:3466),

        Mountain(id:"carstensz", name:"Carstensz Pyramid", imageName:"gunung_carstensz_pyramid", province:"Papua", grade:.v, gradeNote:"Pendakian teknis es & tebing", durationNote:"10-14 hari", durationDays:10...14, specialItems:["Harness + tali panjat","Sepatu climbing","Jaket tebal (suhu di bawah 0°C)"], reference:"TN Lorentz", isCurrentlyClosed:false, closureNote:"", altitude:4884),

        Mountain(id:"trikora", name:"Gunung Trikora", imageName:"gunung_trikora", province:"Papua", grade:.v, gradeNote:"Alpine expedition panjat tebing", durationNote:"7-10 hari", durationDays:7...10, specialItems:["Peralatan panjat","Sepatu high ankle"], reference:"Ekspedisi Mapala", isCurrentlyClosed:false, closureNote:"", altitude:4751),
    ]

    static func filtered(grade: Grade?, query: String) -> [Mountain] {
        return all.filter { mountain in
            let matchesGrade = grade == nil || mountain.grade == grade
            let matchesQuery = query.isEmpty || mountain.name.lowercased().contains(query.lowercased())
            return matchesGrade && matchesQuery
        }
    }
}
