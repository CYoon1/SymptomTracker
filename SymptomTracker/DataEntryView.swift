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
    @State var feverTemp: Double = 98.6
    @State var o2Sat: Double = 100
    @State var notes = ""
    @State var useTemp = false
    @State var useSat = false
    
    var body: some View {
        Form {
            Text("DataEntryView")
            SymptomSeverityPickerView(categoryName: "Cough Severity", selectionSeverity: $coughSeverity)
            SymptomSeverityPickerView(categoryName: "Malaise Severity", selectionSeverity: $malaiseSeverity)
            Button {
                useTemp.toggle()
            } label: {
                HStack {
                    Text("Use Temperature")
                    Spacer()
                    Text(useTemp ? "Yes" : "No")
                }
            }
            if(useTemp) {
                SliderView(categoryName: "Temperature", lowerRange: 95, upperRange: 105, step: 0.1, format: "%.1f", value: $feverTemp)
            } else {
                Text("Temperature : N/A")
            }
            Button {
                    useSat.toggle()
            } label: {
                HStack {
                    Text("Use O2 Saturation")
                    Spacer()
                    Text(useSat ? "Yes" : "No")
                }
            }
            if(useSat) {
                SliderView(categoryName: "O2 Saturation", lowerRange: 90, upperRange: 100, step: 0.01, format: "%.2f", value: $o2Sat)
            } else {
                Text("O2 Saturation: N/A")
            }
            
            // Notes Section
            Section(header: Text("Note")) {
                TextEditor(text: $notes)
                    .opacity(notes.isEmpty ? 0.25 : 1)
                    .font(.custom("HelveticaNeue", size: 13))
                    .padding(.horizontal)
            }
            
            Button {
                // Create Entry
                addEntry(entryData: EntryData(cough: coughSeverity, name: "", fever: feverTemp, malaise: malaiseSeverity, note: notes, o2Sat: o2Sat, useTemp: useTemp, useSat: useSat))
                
                // Reset all to default
                
                // Cough
                coughSeverity = SymptomSeverity.unknown
                
                // Malaise
                malaiseSeverity = SymptomSeverity.unknown
                
                // Fever
                // Use Slider to Tenth.
                feverTemp = 98.6
                
                // O2
                o2Sat = 100
                
                // Notes
                notes = ""
                
                // Toggles
                useTemp = false
                useSat = false
                
            } label: {
                Text("Add")
            }
            
            // List of Entries, Preview Only,  Remove Later
            ForEach(entries) { entry in
                HStack {
                    let cough = SymptomSeverity(rawValue: Int(entry.cough)) ?? .none
                    let malaise = SymptomSeverity(rawValue: Int(entry.malaise)) ?? .none
                    let temp = entry.fever
                    VStack {
                        Text(cough.text)
                        Text(malaise.text)
                        if entry.useTemp {
                            Text("\(temp) degrees")
                        } else {
                            Text("No Temp")
                        }
                    }
                    
//                    EntryDisplayView(entry: entry)
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
            entry.malaise = Int16(entryData.malaise.rawValue)
            entry.useTemp = entryData.useTemp
            entry.fever = entryData.fever
            entry.note = entryData.note
            entry.useSat = entryData.useSat
            entry.o2Sat = entryData.o2Sat
            
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

struct SliderView: View {
    let categoryName: String
    let lowerRange: Double
    let upperRange: Double
    let step: Double
    let format: String
    @Binding var value: Double
    @State var isEditing = false
    
    var body: some View {
        HStack {
            Text("\(categoryName): ")
            Text(String(format: format, value))
                .foregroundColor(isEditing ? .red : .primary)
            Slider(value: $value, in: lowerRange...upperRange, step: step) {
                Text("Temp: \(value)")
                    .foregroundColor(isEditing ? .red : .primary)
            } onEditingChanged: { editing in
                isEditing = editing
            }
        }
    }
}

struct EntryDisplayView: View {
    let entry : Entry
    var body: some View {
        VStack {
            HStack {
                let cough = SymptomSeverity(rawValue: Int(entry.cough)) ?? .none
                Text("Cough")
                Spacer()
                Text("\(cough.text)")
            }
            HStack {
                let malaise = SymptomSeverity(rawValue: Int(entry.malaise)) ?? .none
                Text("Malaise")
                Spacer()
                Text("\(malaise.text)")
            }
            
            HStack {
                let temperature = entry.fever
                Text("Temperature : ")
                Spacer()
                Text("\(entry.useTemp ? String(temperature) : "N/A")")
            }
        }
    }
}
