import SwiftUI

struct SettingsRow<Content: View>: View {
    let icon: String?
    let title: String
    let content: Content
    
    init(icon: String? = nil, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
            }
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(nil) // Allow multiple lines
                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion, no horizontal fixed size
            Spacer()
            content
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.primary.opacity(0.03))
        .cornerRadius(10)
    }
}
