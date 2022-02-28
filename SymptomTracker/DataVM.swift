//
//  DataVM.swift
//  SymptomTracker
//
//  Created by Christopher Yoon on 2/27/22.
//

import Foundation
import Combine

class DataVM: ObservableObject, Identifiable {
    @Published var data : EntryData
    
    var id = ""
    
    init(data : EntryData) {
        self.data = data
    }
    
}
