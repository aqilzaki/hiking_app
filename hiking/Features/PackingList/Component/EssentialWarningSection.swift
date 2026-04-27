// EssentialWarningSection.swift
import SwiftUI

struct EssentialWarningSection: View {
    let uncheckedEssentials: [PackingItem]

    var body: some View {
        Section {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(uncheckedEssentials.count) item penting belum di-cek")
                        .font(.subheadline.weight(.semibold))
                    Text(uncheckedEssentials.prefix(2).map { $0.name }.joined(separator: ", ")
                         + (uncheckedEssentials.count > 2 ? "..." : ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 2)
        }
        .listRowBackground(Color.orange.opacity(0.08))
    }
}