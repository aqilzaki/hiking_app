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
                bagView
                infoView
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Bag
    private var bagView: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(width: 72, height: 64)

            RoundedRectangle(cornerRadius: 12)
                .fill(progressColor.opacity(0.85))
                .frame(width: 72, height: max(4, 64 * progress))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)

            Rectangle()
                .fill(Color(.systemGray3).opacity(0.5))
                .frame(width: 1, height: 40)
                .offset(y: -6)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(.systemGray4))
                .frame(width: 10, height: 16)
                .offset(x: -16, y: -64)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(.systemGray4))
                .frame(width: 10, height: 16)
                .offset(x: 16, y: -64)

            Capsule()
                .fill(Color(.systemGray3))
                .frame(width: 36, height: 10)
                .offset(y: -58)

            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray3), lineWidth: 1.5)
                .frame(width: 48, height: 22)
                .offset(y: 16)

            Text("\(Int(progress * 100))%")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(progress > 0.3 ? .white : Color(.systemGray))
                .animation(.easeInOut, value: progress)
                .offset(y: -10)
        }
        .frame(width: 72, height: 90)
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