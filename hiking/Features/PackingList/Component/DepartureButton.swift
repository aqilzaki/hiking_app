//  DepartureButton.swift
//  hiking

import SwiftUI

struct DepartureButton: View {
    let mountainName: String
    let onDepart: () -> Void

    @State private var pulse  = false
    @State private var appear = false

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Illustration
            ZStack {
                // Outer pulse ring
                Circle()
                    .stroke(Color.green.opacity(0.15), lineWidth: 1)
                    .frame(width: 110, height: 110)
                    .scaleEffect(pulse ? 1.25 : 1.0)
                    .opacity(pulse ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.8).repeatForever(autoreverses: false),
                        value: pulse
                    )

                // Inner circle
                Circle()
                    .fill(Color.green.opacity(0.08))
                    .frame(width: 88, height: 88)

                // Icon
                Image(systemName: "figure.hiking")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(Color.green)
                    .scaleEffect(appear ? 1 : 0.7)
                    .opacity(appear ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: appear)
            }
            .padding(.bottom, 20)

            // MARK: - Text
            VStack(spacing: 6) {
                Text("Siap Berangkat!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Semua perlengkapan sudah lengkap.\nSelamat mendaki \(mountainName).")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 8)
            .animation(.easeOut(duration: 0.4).delay(0.2), value: appear)
            .padding(.bottom, 24)

            // MARK: - Divider
            Divider()
                .padding(.horizontal, 16)
                .padding(.bottom, 20)

            // MARK: - Button
            Button(action: onDepart) {
                HStack(spacing: 8) {
                    Text("Yuk Berangkat")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 16)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 12)
            .animation(.easeOut(duration: 0.4).delay(0.3), value: appear)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
        .padding(.horizontal, 16)
        .onAppear {
            appear = true
            pulse  = true
        }
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: configuration.isPressed)
    }
}
