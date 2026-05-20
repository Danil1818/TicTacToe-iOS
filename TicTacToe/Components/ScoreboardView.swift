import SwiftUI

struct ScoreboardView: View {
    let xTitle: String
    let oTitle: String
    let scoreX: Int
    let scoreO: Int
    let scoreDraw: Int
    let currentPlayer: Player
    let isFinished: Bool

    var body: some View {
        HStack(spacing: 8) {
            scoreCard(title: xTitle, score: scoreX, isActive: currentPlayer == .x && !isFinished)
            scoreCard(title: oTitle, score: scoreO, isActive: currentPlayer == .o && !isFinished)
            scoreCard(title: "Ничьи", score: scoreDraw, isActive: false)
        }
    }

    private func scoreCard(title: String, score: Int, isActive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("\(score)")
                .font(.title2.weight(.black))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
        .padding(.horizontal, 12)
        .background(.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isActive ? Color.teal : Color.clear, lineWidth: 2)
        }
    }
}
