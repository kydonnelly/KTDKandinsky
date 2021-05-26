//
//  Instrument.swift
//  KTDKandinsky
//
//  Created by Kyle Donnelly on 5/25/21.
//

import Foundation

public enum Scheme: String {
    case electricbass
    case strings
    case marimba
    case dumguitar
    case laachoir
    case beebop
    case rockkit
    case glock
    case kit
}

public enum Instrument: Int, CaseIterable {
    case percussion
    case tonal
    case voice
    
    public var schemes: [Scheme] {
        switch self {
        case .tonal:
            return [.electricbass, .strings, .marimba]
        case .voice:
            return [.dumguitar, .laachoir, .beebop]
        case .percussion:
            return [.rockkit, .glock, .kit]
        }
    }
    
    var numScales: Int {
        switch self {
        case .tonal:
            return 8
        case .voice:
            return 8
        case .percussion:
            return 6
        }
    }
}
