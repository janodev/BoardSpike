
import Foundation

/// Model for the whole board.
final class Board {
    
    var boards = [BoardViewCellModel]()
    
    init() {}

    /// Initializer
    /// - Parameter boards: array of column models
    init(boards: [BoardViewCellModel]) {
        
        self.boards = boards
    }
}

extension Board: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(boards)
    }
    
    static func == (lhs: Board, rhs: Board) -> Bool {
        
        lhs.boards == rhs.boards
    }
}

extension Board: DraggableSource
{
    // MARK: - Collection
    
    var items: [BoardViewCellModel] {
        get { boards }
        set { boards = newValue }
    }
}

// turn this into a board of boardviewcellmodels,
// and change the diffable data source to change the source in sync
