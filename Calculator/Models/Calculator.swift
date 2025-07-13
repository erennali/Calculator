//
//  Calculator.swift
//  Calculator
//
//  Created by Eren Ali Koca on 13.07.2025.
//

import Foundation

enum Input: Int, CaseIterable {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    case dot, clear, sign, percent, divide, multiply, subtract, add, equals
    
    var symbol: String {
            if isDigit { return "\(rawValue)" }
            return [
                10: ".",
                11: "AC",
                12: "±",
                13: "%",
                14: "÷",
                15: "×",
                16: "-",
                17: "+",
                18: "="
            ][rawValue] ?? ""
        }
    
      var isDigit: Bool { rawValue < 10 }
      var isOperator: Bool { (14...17).contains(rawValue) }
      
      func apply(_ inputL: Decimal, _ inputR: Decimal) -> Decimal? {
          switch self {
          case .add: inputL + inputR
          case .subtract: inputL - inputR
          case .multiply: inputL * inputR
          case .divide: inputR.isZero ? nil : inputL / inputR
          default: inputR
          }
      }
  }

struct Display {
    let result: String
    let detail: String
    static let zero = Display(result: "0", detail: "")
}
    
