// Apr 18, 2023
// Ben Roberts

import MapKit
import SwiftUI

/// View for show look around
///
/// Followed this resource: https://www.youtube.com/watch?v=wVqrQ-3TSok
struct LookAroundV: UIViewControllerRepresentable {
    @Binding var location: CLLocationCoordinate2D
    @Binding var showLookAroundView: Bool
    
    /// Sets up the look around view controller
    /// - Returns: The controller to use
    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        return MKLookAroundViewController()
    }
    
    /// When there's an update to the controller, get data needed to display features
    /// - Parameters:
    ///   - uiViewController: Controller managing experience
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        Task {
            if let scene = await getScene(location: .init(latitude: location.latitude, longitude: location.longitude)) {    // If a scene was returned...
                if !self.showLookAroundView {                                                                                   // ...And we're not showing the look around view (prevents endless looping)...
                    withAnimation {
                        self.showLookAroundView = true                                                                              // Begin showing the look around view
                        uiViewController.scene = scene                                                                              // Set the controller to the current position data
                    }
                }
            } else {                                                                                                        // Otherwise...
                if self.showLookAroundView {                                                                                    // ...if we aren't showing the scne...
                    withAnimation {
                        self.showLookAroundView = false                                                                             // Continue not showing the scene
                    }
                }
            }
        }
    }
    
    /// Downloads the scene for the device to display
    /// - Parameter location: Coordinates the scene takes place at
    /// - Returns: The newly downloaded scene
    func getScene(location: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        let sceneRequest = MKLookAroundSceneRequest(coordinate: location)           // Generate look around scene request
        
        do {
            return try await sceneRequest.scene                                         // Put in request and return it if possible
        } catch {
            return nil                                                                  // Otherwise return nil
        }
    }
    
    /// Checks to see if it's possible to show a look around view at a given location
    /// - Parameter location: Location to check
    /// - Returns: Bool of if it's possible
    public static func lookAroundPossible(location: CLLocationCoordinate2D) async -> Bool {
        let sceneRequest = MKLookAroundSceneRequest(coordinate: location)           // Generate look around scene request
        do {
            if try await sceneRequest.scene == nil {                                    // If the request is nil...
                return false                                                                // Return false
            }
            return true                                                                 // Otherwise return true
        }
        catch {
            return false                                                                // If something goes wrong, return nil
        }
    }
}
