// Apr 16, 2023
// Ben Roberts

import SwiftUI

final class UngeneratedActivityPaneVM: ObservableObject {
    /// Activity the pane is for
    @Published var activity: Activity
    /// Controller for the tag picker sheet
    @Published var showTagPicker: Bool
    /// Label to display in pane
    @Published var label: String
    /// Tracks the current status of editing a trip
    @ObservedObject var editingTracker: EditingTrackerM
    /// Trip locations specified by the user
    @ObservedObject var tripLocations: TripLocations
    
    init(tripLocations: TripLocations, activity: Activity, editingTracker: EditingTrackerM) {
        self.activity = activity
        self.showTagPicker = false
        self.label = ""
        self.editingTracker = editingTracker
        self.tripLocations = tripLocations
        generateLabel()
    }
    
    /// Generates the label for the UngeneratedActivityPane
    internal func generateLabel() {
        /// Groups to be shown on the label.
        ///
        /// This is a set to prevent duplicates from appearing.
        var groups: Set<String> = []
        for tagID in activity.tagIDs {                                          // For each tagID in the activitiy...
            guard let tag = TagManager.shared.searchID(id: tagID),                  // Find its tag to...
                  let topic = TagManager.shared.locateTagTopic(tag: tag),          // ...find its topic to...
                  let group = TagManager.shared.locateTopicGroup(topic: topic)      // ...find its group
            else { return }
            groups.insert(group.name)                                           // And add it to the set
        }
        
        var label = ""
        for groupName in groups.sorted() {                                      // Sort the set alphabetically
            label += "\(groupName), "                                               // And add each item to the label
        }
        self.label = String(label.dropLast(2))  // Remove last ", "             // Then set the temp label to the real one
    }
    
    // Check editing status
    internal func checkEditing() {
        self.objectWillChange.send()
    }
}
