import SwiftUI

struct StarterView: View {
    let mountain: Mountain
    @StateObject private var vm = StarterViewModel()
    @State private var showActiveAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                TripImagePickerCard(imageName: mountain.imageName)
                DurasiSection(vm: vm)
                JumlahOrangRow(jumlahOrang: $vm.jumlahOrang)
                StarterCTAButton(canProceed: vm.canProceed) {
                    if TripStorage.shared.loadActiveTrip() != nil {
                        showActiveAlert = true
                    } else {
                        vm.createAndStartTrip()
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            vm.selectedMountain = mountain
        }
        .navigationDestination(isPresented: $vm.tripCreated) {
            if let trip = vm.createdTrip {
                PackingListView(trip: trip)
            }
        }
        .alert("Sedang Dalam Perjalanan", isPresented: $showActiveAlert) {
            Button("Oke", role: .cancel) { }
        } message: {
            Text("Kamu masih dalam pendakian aktif. Selesaikan dulu perjalananmu sebelum memulai yang baru.")
        }
    }
}


