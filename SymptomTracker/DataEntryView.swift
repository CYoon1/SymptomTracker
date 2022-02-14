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
    
    enum coughSeverity: Int, CaseIterable {
        case none = 0, mild, moderate, severe
        var text: String {
            switch self {
            case .none:
                return "none"
            case .mild:
                return "mild"
            case .moderate:
                return "moderate"
            case .severe:
                return "severe"
            }
        }
    }
    
    @State var coughSeverityIndex = 0
    
    
    
    var body: some View {
        Form {
            Text("DataEntryView")
            Picker("Cough Severity", selection: $coughSeverityIndex) {
                ForEach(0..<coughSeverity.allCases.count) {
                    Text(coughSeverity.allCases[$0].text).tag($0)
                }
            }
            Button {
                addEntry(cough: coughSeverityIndex)
            } label: {
                Text("Add")
            }
            ForEach(entries) { entry in
                Text("Cough: \(entry.cough)")
            }

        }
    }
}
extension DataEntryView {
    private func addEntry(cough: Int) {
        withAnimation {
            let entry = Entry(context: viewContext)
            entry.timeStamp = Date()
            entry.cough = Int16(cough)
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
        NavigationView {
            DataEntryView()
        }
    }
}
