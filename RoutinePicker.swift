//
//  RoutinePicker.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 17/05/2026.
//

import Foundation

enum Routine: String, CaseIterable, PickerOption {
    case morning
    case lunch
    case night
    case random
    
    var title: String {
        switch self {
        case .morning: "Morning routine"
        case .lunch: "Quick break"
        case .night: "Nightly ritual"
        case .random: "Randomly"
        }
    }
    
    var subtitle: String {
        switch self {
        case .morning: "During breakfast or my commute"
        case .lunch: "During lunch or between activities"
        case .night: "Typically after dinner or while in bed"
        case .random: "Can't say yet; I'll just wing it as I go"
        }
    }
    
    func imageName(isSelected: Bool) -> String {
        "\(rawValue)\(isSelected ? "True" : "False")"
    }
}

