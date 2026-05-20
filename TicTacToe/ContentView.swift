import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, Color(red: 0.11, green: 0.18, blue: 0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                header
                modePicker

                ScoreboardView(
                    xTitle: viewModel.xScoreTitle,
                    oTitle: viewModel.oScoreTitle,
                    scoreX: viewModel.scoreX,
                    scoreO: viewModel.scoreO,
                    scoreDraw: viewModel.scoreDraw,
                    currentPlayer: viewModel.currentPlayer,
                    isFinished: viewModel.result != nil
                )

                Text(viewModel.statusText)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.thinMaterial, in: Capsule())

                BoardView(viewModel: viewModel)

                if viewModel.result != nil {
                    ResultView(
                        title: viewModel.resultTitle,
                        description: viewModel.resultDescription,
                        restartAction: viewModel.restart
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(20)
            .frame(maxWidth: 430)
            .animation(.spring(response: 0.35, dampingFraction: 0.86), value: viewModel.result != nil)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("iPhone game")
                    .font(.caption.weight(.heavy))
                    .textCase(.uppercase)
                    .foregroundStyle(.teal)

                Text("Крестики-нолики")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.75)
            }

            Spacer()

            Button(action: viewModel.restart) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.13), in: Circle())
            }
            .accessibilityLabel("Restart game")
        }
    }

    private var modePicker: some View {
        Picker("Game mode", selection: $viewModel.gameMode) {
            ForEach(GameMode.allCases) { mode in
                Text(mode.title).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
}
