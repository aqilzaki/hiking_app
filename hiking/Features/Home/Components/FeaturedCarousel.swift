import SwiftUI

struct FeaturedCarousel: View {
    let activeTrip: (name: String, province: String, grade: Grade, day: Int, totalDays: Int)?
    let mountains: [Mountain]

    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    sideCard(index: 0, geo: geo)
                    centerCard(geo: geo)
                    sideCard(index: 1, geo: geo)
                }
                .padding(.horizontal, geo.size.width * -0.1)
            }
        }
    }

    @ViewBuilder
    private func centerCard(geo: GeometryProxy) -> some View {
        let width = geo.size.width * 0.6

        ZStack(alignment: .bottom) {
            // Gambar gunung
            if let trip = activeTrip {
                // Cari mountain dari database berdasarkan nama
                let mountain = MountainDatabase.all.first(where: { $0.name == trip.name })
                Image(mountain?.imageName ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: 220)
                    .clipped()
            } else {
                Image(mountains[safe: 0]?.imageName ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: 220)
                    .clipped()
            }

            // Overlay gelap
            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .center,
                endPoint: .bottom
            )

            // Content
            VStack(alignment: .leading, spacing: 6) {
                if let trip = activeTrip {
                    HStack(spacing: 4) {
                        Circle().fill(.green).frame(width: 7, height: 7)
                        Text("Sedang Mendaki")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(.green.opacity(0.35))
                    .clipShape(Capsule())

                    Spacer()

                    Text(trip.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)

                    Label(trip.province, systemImage: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))

                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: Double(trip.day), total: Double(trip.totalDays))
                            .tint(.white)
                        Text("Hari \(trip.day) dari \(trip.totalDays)")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                } else {
                    Text("Rekomendasi")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())

                    Spacer()

                    Text(mountains[safe: 0]?.name ?? "")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)

                    Label(mountains[safe: 0]?.province ?? "", systemImage: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: width, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
    }

    @ViewBuilder
    private func sideCard(index: Int, geo: GeometryProxy) -> some View {
        let width = geo.size.width * 0.28
        let isLeft = index == 0

        let centerMountain = activeTrip != nil
            ? MountainDatabase.all.first(where: { $0.name == activeTrip!.name })
            : mountains[safe: 0]

        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: gradientColors(centerMountain?.grade ?? .i),
                    startPoint: isLeft ? .trailing : .leading,
                    endPoint: isLeft ? .leading : .trailing
                ))

            VStack(alignment: isLeft ? .trailing : .leading, spacing: 12) {
                if isLeft {
                    // Hari / durasi
                    infoRow(icon: "figure.hiking",
                            value: activeTrip != nil
                                ? "Hari \(activeTrip!.day)/\(activeTrip!.totalDays)"
                                : "\(centerMountain?.durationNote ?? "")",
                            isLeft: isLeft)

                    // Ketinggian
                    infoRow(icon: "arrow.up.circle.fill",
                            value: "\(centerMountain?.altitude ?? 0)m",
                            isLeft: isLeft)

                } else {
                    // Grade
                    infoRow(icon: "chart.bar.fill",
                            value: centerMountain?.grade.rawValue ?? "",
                            isLeft: isLeft)

                    // Jumlah orang
                    infoRow(icon: "person.2.fill",
                            value: activeTrip != nil ? "\(activeTrip!.day) orang" : "2+ orang",
                            isLeft: isLeft)

                    // Status buka/tutup
                    infoRow(icon: centerMountain?.isCurrentlyClosed == true
                                ? "exclamationmark.triangle.fill"
                                : "checkmark.circle.fill",
                            value: centerMountain?.isCurrentlyClosed == true ? "Tutup" : "Buka",
                            isLeft: isLeft)
                }
            }
            .padding(isLeft ? .trailing : .leading, 8)
            .frame(maxWidth: .infinity, alignment: isLeft ? .trailing : .leading)
        }
        .frame(width: width, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(0.9)
        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
    }

    @ViewBuilder
    private func infoRow(icon: String, value: String, isLeft: Bool) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
            Text(value)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(isLeft ? .trailing : .leading)
                .minimumScaleFactor(0.6)
        }
    }
}
