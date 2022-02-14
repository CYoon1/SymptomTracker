//
//  DataEntryView.swift
//  SymptomTracker
//
//  Created by Tim Yoon on 2/13/22.
//

import SwiftUI

struct DataEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default) private var entries: FetchedResults<Entry>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
extension DataEntryView {
    private func addEntry() {
        withAnimation {
            let entry = Entry(context: viewContext)
            entry.timeStamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { entries[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
struct DataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DataEntryView()
    }
}
