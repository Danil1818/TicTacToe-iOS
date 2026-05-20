import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: GameViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        GeometryReader { geometry in
            let cellSide = (geometry.size.width - 20) / 3

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    CellView(
                        player: viewModel.board[index],
                        isWinning: viewModel.isWinningCell(index)
                    ) {
                        viewModel.selectCell(at: index)
                    }
                    .frame(width: cellSide, height: cellSide)
                    .disabled(viewModel.board[index] != nil || viewModel.result != nil)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tic tac toe board")
    }
}
