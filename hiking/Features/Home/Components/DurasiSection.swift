//
//  DurasiSection.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//
import SwiftUI

struct DurasiSection: View {
    @ObservedObject var vm: StarterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Durasi nya Berapa Lama")
                .font(.system(size: 17, weight: .semibold))

            VStack(spacing: 0) {
                datePickerRow
                Divider()
                estimasiRow
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if let mountain = vm.selectedMountain {
                durasiInfo(mountain: mountain)
            }
        }
    }

    private var datePickerRow: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Start").font(.caption).foregroundStyle(.secondary)
                DatePicker("", selection: $vm.startDate, displayedComponents: .date)
                    .labelsHidden()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text("End").font(.caption).foregroundStyle(.secondary)
                DatePicker("", selection: $vm.endDate, in: vm.minimumEndDate..., displayedComponents: .date)
                    .labelsHidden()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
        }
    }

    private var estimasiRow: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 13))
                Text("Estimasi")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
                Text(vm.estimasiText)
                    .font(.system(size: 15))
                    .foregroundStyle(vm.durasiValid ? Color.primary : Color.orange)
            }
            .padding(14)

            if vm.showMinDurationWarning {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                    Text("Durasi minimum \(vm.minDurasiHari) hari untuk gunung ini")
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.showMinDurationWarning)
    }

    private func durasiInfo(mountain: Mountain) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.system(size: 12))
                .foregroundStyle(.blue)
            Text("\(mountain.name) butuh minimal \(mountain.durationDays.lowerBound)–\(mountain.durationDays.upperBound) hari")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
        .transition(.opacity)
        .animation(.easeInOut, value: vm.selectedMountain?.id)
    }
}
