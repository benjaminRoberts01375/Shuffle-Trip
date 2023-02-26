// Feb 2, 2023
// Ben Roberts

import SwiftUI

/// Tracks information about the user searching
class DrawerController: ObservableObject {
    private var isFullTodoList: [() -> Void] = []
    
    /// Controls the bottom card being set to its maximum height
    @Published var isFull: Bool {
        didSet {
            for action in isFullTodoList {
                action()
            }
        }
    }
    
    init () {
        isFull = false
    }
    
    init (isFull: Bool, isPresented: Bool) {
        self.isFull = isFull
    }
        
    /// Add code to be called when the user begins/finishes searching
    /// - Parameter action: Code that is called when the user begins/ finishes editing a search bar.
    public func AddUserSearchingAction(action: @escaping () -> Void) {
        isFullTodoList.append(action)
    }
}
