//
//  StarterCTAButton.swift
//  hiking
//
//  Created by muhammad aqil zaki on 14/04/26.
//
import SwiftUI

struct StarterCTAButton: View {
    let canProceed: Bool
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            Text(canProceed ? "Yuk kita List" : "Pilih gunung dulu")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canProceed ? Color.blue : Color(.systemGray4))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.default, value: canProceed)
            
        }
        .disabled(!canProceed)
        .padding(.top, 4)
    }
}
