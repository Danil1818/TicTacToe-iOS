import SwiftUI

struct CellView: View {
    let player: Player?
    let isWinning: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isWinning ? Color.teal.opacity(0.32) : Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isWinning ? Color.teal : Color.white.opacity(0.35), lineWidth: 2)
                    }

                Text(player?.rawValue ?? "")
                    .font(.system(size: 78, weight: .black, design: .rounded))
                    .foregroundStyle(player?.color ?? .clear)
                    .minimumScaleFactor(0.55)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(StableCellButtonStyle())
        .accessibilityLabel(accessibilityTitle)
    }

    private var accessibilityTitle: String {
        guard let player else {
            return "Empty cell"
        }

        return "\(player.rawValue) cell"
    }
}

private struct StableCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}
