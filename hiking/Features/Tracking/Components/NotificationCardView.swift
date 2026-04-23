//
//  NotificationCardView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 13/04/26.
//


import SwiftUI

struct NotificationCardView: View {
    let currentDay: Int
    let totalDays: Int
    let mountainName: String
    var summitDay: Int {
        (totalDays / 2) + (totalDays % 2)
    }

    var notifTitle: String {
        switch currentDay {
        case 1:           return "Hari Pertama! 🎒"
        case summitDay:   return "Kamu di Puncak! 🏔️"
        default:          return "Hari ke-\(currentDay) 💪"
        }
    }

    var notifMessage: String {
        switch currentDay {
        case 1:
            return "Jangan lupa cek barang bawaan sebelum mulai pendakian"
            
        case summitDay:
            return "Hari ini summit \(mountainName)! 🎉\nBiasanya berangkat dini hari, tetap fokus & jaga keselamatan"
            
        case totalDays:
            return "Perjalanan turun selesai 🙌\nPastikan semua barang tidak tertinggal"
            
        default:
            return "Lanjut perjalanan di \(mountainName)\nJaga stamina, hidrasi, dan istirahat"
        }
    }

    var notifIcon: String {
        switch currentDay {
        case 1:
            return "bell.badge.fill"
        case summitDay:
            return "flag.checkered"
        case totalDays:
            return "checkmark.circle.fill"
        default:
            return "info.circle.fill"
        }
    }

    var notifColor: Color {
        switch currentDay {
        case summitDay:
            return .orange
        case totalDays:
            return .green
        default:
            return .blue
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: notifIcon)
                .font(.system(size: 20))
                .foregroundStyle(notifColor)
                .frame(width: 40, height: 40)
                .background(notifColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text("Notifikasi")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(notifTitle)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
                Text(notifMessage)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}
