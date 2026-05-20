import SwiftUI

struct ResultView: View {
    let title: String
    let description: String
    let restartAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            Text(description)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white.opacity(0.72))

            Button(action: restartAction) {
                Text("Restart")
                    .font(.headline.weight(.black))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.teal, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(18)
        .background(Color.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
