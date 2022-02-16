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
    
    init(cough : SymptomSeverity = .unknown, fever: Double = 0, malaise : SymptomSeverity = .unknown, note: String = "", o2Sat : Double = 0) {
        self.cough = cough
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
