import SwiftUI

struct TripImagePickerCard: View {
    let imageName: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            // Overlay gradient supaya kalau ada teks di atas terbaca
            LinearGradient(
                colors: [.clear, .black.opacity(0.3)],
                startPoint: .center,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .frame(height: 190)
    }
}

#Preview {
    TripImagePickerCard(imageName: "gunung_rinjani")
}
