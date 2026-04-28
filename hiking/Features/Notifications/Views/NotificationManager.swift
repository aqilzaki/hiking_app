//
//  NotificationManager.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//


//  NotificationManager.swift
//  hiking

import UserNotifications
import Foundation

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // MARK: - Request Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            print("🔔 Notifikasi permission: \(granted)")
            return granted
        } catch {
            print("❌ Notifikasi error: \(error)")
            return false
        }
    }

    // MARK: - Schedule
    func schedulePackingReminder(trip: Trip) {
   
        let intervals: [(seconds: Double, message: String)] = [
            (10,  "Hei! Sudah cek barang bawaan belum? 🎒"),
            (20,  "Jangan lupa sleeping bag ya! 🛌"),
            (30,  "Cek lagi P3K dan obat pribadimu 💊"),
            (40,  "Dokumen & SIMAKSI sudah siap? 📋"),
            (50,  "Hampir waktunya berangkat! Semua sudah lengkap? ✅"),
        ]

        for (index, notif) in intervals.enumerated() {
            let content         = UNMutableNotificationContent()
            content.title       = "Cek Barang — \(trip.mountainName)"
            content.body        = notif.message
            content.sound       = .default
            content.badge       = (index + 1) as NSNumber

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: notif.seconds,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: "packing-reminder-\(index)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print("❌ Gagal schedule notif \(index): \(error)")
                } else {
                    print("✅ Notif \(index) dijadwalkan — \(notif.seconds)s lagi")
                }
            }
        }
    }

}
