// Feb 2, 2023
// Ben Roberts

import SwiftUI

/// Tracks information about the user searching
class SearchTracker: ObservableObject {
    private var todoList: [() -> Void] = []
    
    @Published var isFull: Bool
    {
        didSet {
            for action in todoList {
                action()
            }
        }
    }
    
    init () {
        isFull = false
    }
    init (cardState: Bool) {
        isFull = cardState
    }
        
    /// Add code to be called when the user begins/finishes searching
    /// - Parameter action: Code that is called when the user begins/ finishes editing a search bar.
    public func AddUserSearchingAction(action: @escaping () -> Void) {
        todoList.append(action)
    }
}
