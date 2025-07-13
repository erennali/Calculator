//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Eren Ali Koca on 13.07.2025.
//

import Foundation

// MARK: - Operation
enum Operation: String, CaseIterable {
    case add = "+", subtract = "-", multiply = "*", divide = "/"
    
    func calculate(_ inputL: Double, _ inputR: Double) -> Double {
        switch self {
        case .add: return inputL + inputR
        case .subtract: return inputL - inputR
        case .multiply: return inputL * inputR
        case .divide: return inputR != 0 ? inputL / inputR : .nan
        }
    }
}

final class CalculatorManager {
    
}
