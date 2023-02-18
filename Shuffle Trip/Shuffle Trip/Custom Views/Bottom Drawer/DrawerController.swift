// Feb 2, 2023
// Ben Roberts

import SwiftUI

/// Tracks information about the user searching
class DrawerController: ObservableObject {
    private var isFullTodoList: [() -> Void] = []
    private var isPresentedTodoList: [() -> Void] = []
    
    /// Controls the bottom card being set to its maximum height
    @Published var isFull: Bool {
        didSet {
            for action in isFullTodoList {
                action()
            }
        }
    }
    
    /// Controls the bottom card being shown on screen or not
    @Published var isPresented: Bool {
        didSet {
            for action in isPresentedTodoList {
                action()
            }
        }
    }
    
    init () {
        isFull = false
        isPresented = true
    }
    init (isFull: Bool, isPresented: Bool) {
        self.isFull = isFull
        self.isPresented = isPresented
    }
        
    /// Add code to be called when the user begins/finishes searching
    /// - Parameter action: Code that is called when the user begins/ finishes editing a search bar.
    public func AddUserSearchingAction(action: @escaping () -> Void) {
        isFullTodoList.append(action)
    }
    
    /// Add code to be called when a drawer should be shown or hidden
    /// - Parameter action: Code that is called when the drawer is presented or hidden
    public func AddPresentedAction(action: @escaping () -> Void) {
        isPresentedTodoList.append(action)
    }
}
