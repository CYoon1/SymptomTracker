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
    
    
    
    @State var coughSeverityIndex = 0
    
    
    
    var body: some View {
        Form {
            Text("DataEntryView")
            Picker("Cough Severity", selection: $coughSeverityIndex) {
                ForEach(0..<SymptomSeverity.allCases.count) {
                    Text(SymptomSeverity.allCases[$0].text).tag($0)
                }
            }
            Button {
                addEntry(entryData: EntryData(cough: SymptomSeverity(rawValue: coughSeverityIndex) ?? .unknown))
                coughSeverityIndex = 0
            } label: {
                Text("Add")
            }
            ForEach(entries) { entry in
                HStack {
                    let cough = SymptomSeverity(rawValue: Int(entry.cough)) ?? .none
                    Text(cough.text)
//                    Text("Cough: \(entry.cough)")
                }
            }

        }
    }
}
extension DataEntryView {
    private func addEntry(entryData: EntryData) {
        withAnimation {
            let entry = Entry(context: viewContext)
            
            entry.timeStamp = entryData.timeStamp
            entry.cough = Int16(entryData.cough.rawValue)
            
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
