import SwiftUI

struct NotificationCardView: View {
    let currentDay: Int
    let totalDays: Int
    let mountainName: String

    var notifTitle: String {
        switch currentDay {
        case 1:           return "Hari Pertama! 🎒"
        case totalDays:   return "Kamu di Puncak! 🏔️"
        default:          return "Hari ke-\(currentDay) 💪"
        }
    }

    var notifMessage: String {
        switch currentDay {
        case 1:
            return "Hei jangan lupa untuk cek\nbarang bawaan saat pulang ya"
        case totalDays:
            return "Selamat kamu sudah sampai puncak \(mountainName)! 🎉\nJaga keselamatan saat turun"
        default:
            return "Semangat mendaki \(mountainName)!\nPastikan hidrasi dan istirahat cukup"
        }
    }

    var notifIcon: String {
        switch currentDay {
        case 1:         return "bell.badge.fill"
        case totalDays: return "star.fill"
        default:        return "info.circle.fill"
        }
    }

    var notifColor: Color {
        switch currentDay {
        case totalDays: return .orange
        default:        return .blue
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