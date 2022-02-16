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
    
    @State var coughSeverity = SymptomSeverity.unknown
    @State var malaiseSeverity = SymptomSeverity.unknown
    
    @State var notes = ""
    
    
    var body: some View {
        Form {
            Text("DataEntryView")
            SymptomSeverityPickerView(categoryName: "Cough Severity", selectionSeverity: $coughSeverity)
            SymptomSeverityPickerView(categoryName: "Malaise Severity", selectionSeverity: $malaiseSeverity)
            
            Text("fever Placeholder: Double")
            Text("o2Sat Placeholder: Double")
            
            // Notes Section
            Section(header: Text("Note")) {
                TextEditor(text: $notes)
                    .opacity(notes.isEmpty ? 0.25 : 1)
                    .font(.custom("HelveticaNeue", size: 13))
                    .padding(.horizontal)
            }
            
            Button {
                // Create Entry
                addEntry(entryData: EntryData(cough: coughSeverity, malaise: malaiseSeverity, note: notes))
                
                // Reset all to default
                
                // Cough
                coughSeverity = SymptomSeverity.unknown
                
                // Fever
                // TBA
                
                // Malaise
                malaiseSeverity = SymptomSeverity.unknown
                
                // Notes
                notes = ""
                
            } label: {
                Text("Add")
            }
            
            // List of Entries, Preview Only,  Remove Later
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

struct SymptomSeverityPickerView: View {
    let categoryName: String
    @Binding var selectionSeverity: SymptomSeverity
    @State var selectionIndex: Int = SymptomSeverity.unknown.rawValue
    
    var body: some View {
        Picker(categoryName, selection: $selectionIndex) {
            ForEach(0..<SymptomSeverity.allCases.count) {
                Text(SymptomSeverity.allCases[$0].text).tag($0)
            }.onChange(of: selectionIndex) { newValue in
                selectionSeverity = SymptomSeverity(rawValue: Int(selectionIndex)) ?? .unknown
            }
        }
    }
}
