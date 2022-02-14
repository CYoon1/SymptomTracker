//
//  DataEntryView.swift
//  SymptomTracker
//
//  Created by Tim Yoon on 2/13/22.
//

import SwiftUI
extension Entry {
    var coughSeverity : SymptomSeverity {
        get { SymptomSeverity(rawValue: Int(cough)) ?? .unknown}
        set { cough = Int16(newValue.rawValue)}
    }
}
struct DataEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default) private var entries: FetchedResults<Entry>
    
    
    
    @State var coughSeverityIndex = SymptomSeverity.unknown.rawValue
    @State var coughSeverity = SymptomSeverity.unknown
    
    
    
    var body: some View {
        Form {
            Text("DataEntryView")
            Picker("Cough Severity", selection: $coughSeverityIndex) {
                ForEach(0..<SymptomSeverity.allCases.count) {
                    Text(SymptomSeverity.allCases[$0].text).tag($0)
                }.onChange(of: coughSeverityIndex) { newValue in
                    coughSeverity = SymptomSeverity(rawValue: Int(coughSeverityIndex)) ?? .unknown
                }
            }
            .pickerStyle(.segmented)
            Button {
                addEntry(entryData: EntryData(cough: coughSeverity))
                coughSeverity = SymptomSeverity.unknown
                coughSeverityIndex = coughSeverity.rawValue
                
            } label: {
                Text("Add")
            }
            ForEach(entries) { entry in
                HStack {
                    let cough = SymptomSeverity(rawValue: Int(entry.cough)) ?? .none
                    Text(cough.text)
                }
            }.onDelete(perform: deleteEntries)
                

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
