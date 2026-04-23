//
//  MountainGridCard.swift
//  hiking
//

import SwiftUI

struct MountainGridCard: View {
    let mountain: Mountain
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
                //mountain image
                Image(mountain.imageName)
                       .resizable()
                       .scaledToFill()
                       .frame(width:180 ,height: 140)
                       
                       .clipShape(RoundedRectangle(cornerRadius: 14))

                // Dark overlay gradient (bottom)
                LinearGradient(
                    colors: [.clear, .black.opacity(0.55)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Content
                VStack(alignment: .leading, spacing: 0) {
                    // Top row: grade badge + closed warning
                    HStack(alignment: .top) {
                        Text("\(mountain.grade.label)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.18))
                            .clipShape(Capsule())

                        Spacer()

                        if mountain.isCurrentlyClosed {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.yellow)
                        }
                    }

                    Spacer()

                    // Bottom: name + location + altitude
                    Text(mountain.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 10))
                        Text(mountain.province)
                        if let alt = mountain.altitude {
                            Text("▲ \(alt.formatted())m")
                                .padding(.leading, 4)
                        }
                    }
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(
                color: gradeColor(mountain.grade).opacity(0.3),
                radius: 8,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MountainGridCard(mountain: MountainDatabase.all[0],
                     onTap: {})
}


