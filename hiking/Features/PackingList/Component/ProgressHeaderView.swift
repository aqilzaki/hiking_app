//
//  ProgressHeaderView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//


import SwiftUI

struct ProgressHeaderView: View {
    let progress: Double
    let checkedCount: Int
    let totalCount: Int
    let progressLabel: String
    let progressColor: Color

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 20) {
                infoView
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }


    // MARK: - Info
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(progressLabel)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Text("\(checkedCount) dari \(totalCount) item sudah dipack")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    Capsule()
                        .fill(progressColor)
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.spring(response: 0.5), value: progress)
                }
            }
            .frame(height: 6)

            if totalCount > checkedCount {
                Text("\(totalCount - checkedCount) item lagi")
                    .font(.system(size: 11))
                    .foregroundStyle(progressColor)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

