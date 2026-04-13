// MARK: - Lock Screen View
struct LockScreenView: View {
    let context: ActivityViewContext<HikingActivityAttributes>

    var body: some View {
        HStack(spacing: 14) {
            // Ikon fase besar
            ZStack {
                Circle()
                    .fill(gradeActivityColor(context.attributes.grade).opacity(0.2))
                    .frame(width: 52, height: 52)
                Image(systemName: context.state.phase.sfSymbol)
                    .font(.system(size: 22))
                    .foregroundStyle(gradeActivityColor(context.attributes.grade))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(context.state.mountainName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(context.state.phase.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(gradeActivityColor(context.attributes.grade))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(gradeActivityColor(context.attributes.grade).opacity(0.15))
                        .clipShape(Capsule())
                }

                // Progress bar dengan hiker
                VStack(spacing: 3) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.systemGray5))
                                .frame(height: 6)
                            Capsule()
                                .fill(gradeActivityColor(context.attributes.grade))
                                .frame(width: geo.size.width * context.state.progress, height: 6)
                        }
                        Text(context.state.phase.emoji)
                            .font(.system(size: 14))
                            .offset(x: max(0, geo.size.width * context.state.progress - 12), y: -14)
                    }
                    .frame(height: 6)
                    .padding(.top, 14)
                }

                HStack {
                    Label(context.state.elapsedFormatted, systemImage: "clock.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(context.state.remainingFormatted)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
    }
}