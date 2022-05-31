//
//  EntryCardView.swift
//  SymptomTracker
//
//  Created by Christopher Yoon on 3/6/22.
//

import SwiftUI

struct EntryCardView: View {
    var entry: EntryData
    
    var body: some View {
        VStack {
            Text("Name: \(entry.name)")
            if(entry.useTemp) {
                Text("Temperature: \(entry.fever)")
            } else {
                Text("Temperature: N/A")
            }
            if(entry.useSat) {
                Text("Temperature: \(entry.o2Sat)")
            } else {
                Text("Temperature: N/A")
            }
            Text("Cough Severity: \(entry.cough.text)")
            Text("Malaise Severity: \(entry.malaise.text)")
            Text("Note: \(entry.note)")
        }
    }
}

struct EntryCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
//            ScrollView {
            EntryCardView(entry: EntryData(cough: .moderate, name: "Blank Name", fever: 98.6, malaise: .unknown, note: "Test Note 1", o2Sat: 100, useTemp: true, useSat: true))
            EntryCardView(entry: EntryData(cough: .mild, name: "Blank Name", fever: 98.6, malaise: .severe, note: "Test Note 2", o2Sat: 100, useTemp: false, useSat: false))
                
//            }
        }
    }
}
struct EntryAddView: View {
    var body: some View {
        Text("Test")
    }
}
