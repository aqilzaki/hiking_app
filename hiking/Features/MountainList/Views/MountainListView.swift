//
//  MountainListView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 10/04/26.
//


import SwiftUI

struct MountainListView: View {
    @StateObject private var vm = MountainListViewModel()
    @State private var selectedMountain: Mountain? = nil

    var body: some View {
        NavigationStack {
            List {
                // Grade Filter
                gradeFilterSection
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                // Groups
                ForEach(vm.gradeGroups, id: \.0) { grade, mountains in
                    Section {
                        ForEach(mountains) { mountain in
                            MountainRow(mountain: mountain)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedMountain = mountain }
                        }
                    } header: {
                        GradeSectionHeader(grade: grade)
                    }
                }

                if vm.mountains.isEmpty {
                    emptyState
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Pilih Gunung")
            .searchable(text: $vm.searchText, prompt: "Cari gunung atau provinsi...")
            .navigationDestination(item: $selectedMountain) { mountain in
                MountainDetailView(mountain: mountain)
            }
        }
    }

    // MARK: - Grade Filter
    private var gradeFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(label: "Semua", isSelected: vm.selectedGrade == nil) {
                    vm.selectedGrade = nil
                }
                ForEach(Grade.allCases, id: \.self) { grade in
                    FilterPill(
                        label: grade.label,
                        isSelected: vm.selectedGrade == grade,
                        color: gradeColor(grade)
                    ) {
                        vm.selectedGrade = vm.selectedGrade == grade ? nil : grade
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        ContentUnavailableView(
            "Gunung Tidak Ditemukan",
            systemImage: "mountain.2",
            description: Text("Coba kata kunci lain atau hapus filter")
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}

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

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.tertiaryLabel)
        }
        .padding(.vertical, 4)
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