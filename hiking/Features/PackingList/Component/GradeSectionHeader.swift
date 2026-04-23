//
//  GradeSectionHeader.swift
//  hiking
//
//  Created by muhammad aqil zaki on 21/04/26.
//

import SwiftUI

// MARK: - Grade Section Header
struct GradeSectionHeader: View {
    let grade: Grade

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: grade.sfSymbol)
                .foregroundStyle(gradeColor(grade))
                .font(.system(size: 13, weight: .semibold))
            Text(grade.label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("·")
                .foregroundStyle(.secondary)
            Text(grade.difficultyLabel)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Mountain Row
struct MountainRow: View {
    let mountain: Mountain
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Grade Badge
            Text(mountain.grade.sortOrder.description)
                .font(.system(size: 17, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(gradeColor(mountain.grade).gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(mountain.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                    if mountain.isCurrentlyClosed {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.system(size: 12))
                    }
                }

                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 11))
                    Text(mountain.province)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Text("·")
                        .foregroundStyle(.tertiary)

                    Image(systemName: "clock.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 11))
                    Text(mountain.durationNote)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                if let alt = mountain.altitude {
                    Text("\(alt.formatted())m dpl")
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer()
            
            if isSelected {
                           Image(systemName: "checkmark.circle.fill")
                               .foregroundStyle(gradeColor(mountain.grade))
                               .font(.system(size: 20))
                       } else {
                           Image(systemName: "chevron.right")
                               .font(.system(size: 13, weight: .medium))
                               .foregroundStyle(.tertiary)
                       }
        }
        .padding(.vertical, 4)
        .listRowBackground(
                    // ← background row berubah warna sesuai grade
                    isSelected
                        ? gradeColor(mountain.grade).opacity(0.08)
                        : Color(.secondarySystemGroupedBackground)
                )
                .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
    }
}

// MARK: - Filter Pill
struct FilterPill: View {
    let label: String
    let isSelected: Bool
    var color: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? color : Color(.secondarySystemGroupedBackground))
                .clipShape(Capsule())
                .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Grade Color Helper
func gradeColor(_ grade: Grade) -> Color {
    switch grade {
    case .i:   return .green
    case .ii:  return .blue
    case .iii: return .orange
    case .iv:  return .red
    case .v:   return .purple
    }
}

// Needed for Color to use as .tertiaryLabel
extension Color {
    static var tertiaryLabel: Color { Color(UIColor.tertiaryLabel) }
}


