import SwiftUI

enum Player: String, Equatable {
    case x = "X"
    case o = "O"

    var next: Player {
        self == .x ? .o : .x
    }

    var color: Color {
        switch self {
        case .x:
            return .red
        case .o:
            return .blue
        }
    }
}
