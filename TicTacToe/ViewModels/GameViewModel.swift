import Foundation

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var board: [Player?] = Array(repeating: nil, count: 9)
    @Published private(set) var currentPlayer: Player = .x
    @Published private(set) var result: GameResult?
    @Published private(set) var isComputerThinking = false
    @Published var gameMode: GameMode = .players {
        didSet {
            resetScores()
            restart()
        }
    }

    @Published private(set) var scoreX = 0
    @Published private(set) var scoreO = 0
    @Published private(set) var scoreDraw = 0

    let winningCombinations: [[Int]] = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]

    var statusText: String {
        if isComputerThinking {
            return "Компьютер думает..."
        }

        if let result {
            switch result {
            case .winner(let player, _):
                return "Победил \(player.rawValue)"
            case .draw:
                return "Ничья"
            }
        }

        if gameMode == .computer {
            return currentPlayer == .x ? "Твой ход" : "Ход компьютера"
        }

        return "Ход игрока \(currentPlayer.rawValue)"
    }

    var resultTitle: String {
        guard let result else {
            return ""
        }

        switch result {
        case .draw:
            return "Ничья"
        case .winner(let player, _):
            if gameMode == .computer {
                return player == .x ? "Ты выиграл, молодец!" : "Ты проиграл"
            }

            return "Игрок \(player.rawValue) выиграл"
        }
    }

    var resultDescription: String {
        guard let result else {
            return ""
        }

        switch result {
        case .draw:
            return "Все клетки заполнены, победителя нет."
        case .winner(let player, _):
            if gameMode == .computer {
                return player == .x
                    ? "Ты собрал победную комбинацию быстрее компьютера."
                    : "Компьютер собрал победную комбинацию."
            }

            return "Игрок \(player.rawValue) собрал победную комбинацию."
        }
    }

    var xScoreTitle: String {
        gameMode == .computer ? "Ты" : "Игрок X"
    }

    var oScoreTitle: String {
        gameMode == .computer ? "Компьютер" : "Игрок O"
    }

    func selectCell(at index: Int) {
        guard board.indices.contains(index),
              board[index] == nil,
              result == nil,
              !isComputerThinking,
              !isComputerTurn
        else {
            return
        }

        makeMove(at: index)
    }

    func restart() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
        result = nil
        isComputerThinking = false
    }

    func isWinningCell(_ index: Int) -> Bool {
        guard case .winner(_, let combination) = result else {
            return false
        }

        return combination.contains(index)
    }

    private var isComputerTurn: Bool {
        gameMode == .computer && currentPlayer == .o
    }

    private func makeMove(at index: Int) {
        board[index] = currentPlayer

        if let winningCombination = winningCombination(for: currentPlayer) {
            finish(with: .winner(currentPlayer, combination: winningCombination))
            return
        }

        if board.allSatisfy({ $0 != nil }) {
            finish(with: .draw)
            return
        }

        currentPlayer = currentPlayer.next

        if isComputerTurn {
            performComputerMove()
        }
    }

    private func finish(with result: GameResult) {
        self.result = result

        switch result {
        case .winner(let player, _):
            if player == .x {
                scoreX += 1
            } else {
                scoreO += 1
            }
        case .draw:
            scoreDraw += 1
        }
    }

    private func winningCombination(for player: Player) -> [Int]? {
        winningCombinations.first { combination in
            combination.allSatisfy { board[$0] == player }
        }
    }

    private func performComputerMove() {
        isComputerThinking = true

        Task {
            try? await Task.sleep(for: .milliseconds(450))

            guard result == nil, isComputerTurn else {
                isComputerThinking = false
                return
            }

            isComputerThinking = false

            if let index = bestComputerMove() {
                makeMove(at: index)
            }
        }
    }

    private func bestComputerMove() -> Int? {
        findWinningMove(for: .o)
            ?? findWinningMove(for: .x)
            ?? preferredMove(from: [4])
            ?? preferredMove(from: [0, 2, 6, 8])
            ?? preferredMove(from: [1, 3, 5, 7])
    }

    private func findWinningMove(for player: Player) -> Int? {
        for combination in winningCombinations {
            let playerCells = combination.filter { board[$0] == player }
            let emptyCells = combination.filter { board[$0] == nil }

            if playerCells.count == 2, emptyCells.count == 1 {
                return emptyCells[0]
            }
        }

        return nil
    }

    private func preferredMove(from indexes: [Int]) -> Int? {
        indexes.first { board[$0] == nil }
    }

    private func resetScores() {
        scoreX = 0
        scoreO = 0
        scoreDraw = 0
    }
}
