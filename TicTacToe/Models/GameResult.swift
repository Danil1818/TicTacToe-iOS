enum GameResult: Equatable {
    case winner(Player, combination: [Int])
    case draw
}
