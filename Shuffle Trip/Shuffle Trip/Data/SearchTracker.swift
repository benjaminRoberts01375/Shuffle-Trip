// Feb 2, 2023
// Ben Roberts

import SwiftUI

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
    
    /**
     Code that is called when the user begins or finishes editing a search bar.
     */
    public func AddUserSearchingAction(action: @escaping () -> Void) {
        todoList.append(action)
    }
}
