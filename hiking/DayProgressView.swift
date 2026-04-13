import SwiftUI

struct DayProgressView: View {
    let currentDay: Int
    let totalDays: Int
    let gradeColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                // Hari saat ini
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hari ke")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text("\(currentDay)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(gradeColor)
                }

                Spacer()

                // Dash indicators
                HStack(spacing: 5) {
                    ForEach(1...max(1, totalDays), id: \.self) { day in
                        Capsule()
                            .fill(day <= currentDay ? gradeColor : Color(.systemGray4))
                            .frame(width: day == currentDay ? 24 : 14, height: 4)
                            .animation(.spring(response: 0.3), value: currentDay)
                    }
                }

                Spacer()

                // Total hari
                VStack(alignment: .trailing, spacing: 2) {
                    Text("dari")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text("\(totalDays) days")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    Capsule()
                        .fill(gradeColor)
                        .frame(
                            width: geo.size.width * (totalDays > 0
                                ? min(1.0, Double(currentDay) / Double(totalDays))
                                : 0),
                            height: 6
                        )
                        .animation(.spring(response: 0.5), value: currentDay)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}