//
//  SymptomTrackerApp.swift
//  SymptomTracker
//
//  Created by Christopher Yoon on 2/13/22.
//

import SwiftUI

@main
struct SymptomTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DataEntryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
