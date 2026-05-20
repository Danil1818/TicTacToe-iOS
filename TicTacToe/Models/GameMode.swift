enum GameMode: String, CaseIterable, Identifiable {
    case players
    case computer

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .players:
            return "2 игрока"
        case .computer:
            return "Против компьютера"
        }
    }
}
