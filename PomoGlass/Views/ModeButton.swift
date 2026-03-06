import SwiftUI

struct ModeButton: View {
    let title: String
    let active: Bool
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 18).padding(.vertical, 10)
                .background(active ? color.opacity(0.12) : Color.primary.opacity(0.04))
                .foregroundColor(active ? color : Color.secondary)
                .cornerRadius(14)
        }.buttonStyle(PlainButtonStyle())
    }
}
