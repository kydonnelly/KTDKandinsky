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
    case crashed
    case mallety
    case funk
    case dumguitar
    case laachoir
    case beebop
    case rockkit
    case glock
    case kit
    case metal
}

public enum Instrument: Int, CaseIterable {
    case percussion
    case pluck
    case tonal
    case voice
    
    public var schemes: [Scheme] {
        switch self {
        case .tonal:
            return [.electricbass, .strings, .marimba, .metal]
        case .voice:
            return [.dumguitar, .laachoir, .beebop]
        case .pluck:
            return [.crashed, .mallety, .funk, .metal]
        case .percussion:
            return [.rockkit, .glock, .kit, .metal]
        }
    }
    
    var numScales: Int {
        switch self {
        case .tonal:
            return 8
        case .voice:
            return 8
        case .pluck:
            return 8
        case .percussion:
            return 6
        }
    }
}
