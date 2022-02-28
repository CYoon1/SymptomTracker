//
//  EntryData.swift
//  SymptomTracker
//
//  Created by Christopher Yoon on 2/13/22.
//

import Foundation

struct EntryData: Identifiable {
    var id: String = UUID().uuidString
    
    var cough: SymptomSeverity = .unknown
    var malaise: SymptomSeverity = .unknown
    var fever: Double = 0
    var o2Sat: Double = 0
    var note: String = ""
    var timeStamp = Date()
    
    var useTemp: Bool = false
    var useSat: Bool = false
    
    init(cough : SymptomSeverity = .unknown, fever: Double, malaise : SymptomSeverity = .unknown, note: String, o2Sat : Double, useTemp: Bool, useSat: Bool) {
        self.cough = cough
        self.fever = fever
        self.malaise  = malaise
        self.note = note
        self.o2Sat = o2Sat
        self.useTemp = useTemp
        self.useSat = useSat
    }
}

enum SymptomSeverity: Int, CaseIterable {
    case none = 0, mild, moderate, severe, unknown
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
        case .unknown:
            return "not specified"
        }
    }
}
