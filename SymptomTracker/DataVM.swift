//
//  DataVM.swift
//  SymptomTracker
//
//  Created by Christopher Yoon on 2/27/22.
//

import Foundation


class DataVM: ObservableObject, Identifiable {
    @Published var data : EntryData
    
    var id = ""
    
    init() {
        self.data = EntryData(cough: SymptomSeverity.unknown, fever: 0, malaise: SymptomSeverity.unknown, note: "", o2Sat: 0)
    }
    
}
