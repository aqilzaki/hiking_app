//
//  JumlahOrangRow.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//
import SwiftUI

struct JumlahOrangRow: View {
    @Binding var jumlahOrang: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Berapa Orang nih Kamu")
                .font(.system(size: 17, weight: .semibold))

            HStack(spacing: 12) {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 1) {
                    Text("Jumlah pendaki").font(.caption).foregroundStyle(.secondary)
                    Text("\(jumlahOrang) orang").font(.system(size: 16))
                }

                Spacer()

                HStack(spacing: 0) {
                    Button {
                        jumlahOrang = max(1, jumlahOrang - 1)
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 36, height: 36)
                            .foregroundStyle(jumlahOrang > 1 ? .blue : .secondary)
                    }

                    Text("\(jumlahOrang)")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36)

                    Button {
                        jumlahOrang = min(20, jumlahOrang + 1)
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 36, height: 36)
                            .foregroundStyle(.blue)
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
