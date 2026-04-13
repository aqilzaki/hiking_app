import SwiftUI

struct DepartureButton: View {
    let mountainName: String
    let onDepart: () -> Void
    @State private var animate = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(animate ? 0.15 : 0))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)

                VStack(spacing: 4) {
                    Text("🏔️")
                        .font(.system(size: 52))
                        .scaleEffect(animate ? 1.05 : 0.95)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
                    Text("🥾")
                        .font(.system(size: 24))
                        .offset(x: animate ? 12 : -12)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate)
                }
            }
            .onAppear { animate = true }

            Text("Semua barang sudah dipack!")
                .font(.system(size: 17, weight: .semibold))

            Text("Saatnya berangkat mendaki\n\(mountainName) 🎉")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onDepart) {
                HStack(spacing: 10) {
                    Image(systemName: "figure.hiking").font(.system(size: 17))
                    Text("Yuk Berangkat! 🚀").font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(LinearGradient(
                    colors: [.green, .mint],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .green.opacity(0.4), radius: 12, y: 6)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
    }
}