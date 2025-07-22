//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Eren Ali Koca on 13.07.2025.
//

import Foundation

final class CalculatorManager {
    private var display = "0"
    private var detail = ""
    private var memory = Decimal.zero
    private var operation: Input?
    private var typing = false
    private var reset = false
    private var expression = ""
    
    private var value: Decimal { Decimal(string: display) ?? .zero }
    
    private let formatter = NumberFormatter().then {
        $0.maximumFractionDigits = 8
        $0.usesGroupingSeparator = false
    }
    
    var state: Display {
        let showExpression = !expression.isEmpty ? expression : display
        return Display(result: showExpression, detail: detail)
    }
    
    func input(_ tag: Int) -> Display {
        guard let input = Input(rawValue: tag) else { return state }
        
        switch input {
        case let digit where digit.isDigit: handleDigit(digit)
        case .dot: handleDot()
        case .clear: clear()
        case .sign: display = format(-value)
        case .percent: display = format(value / 100)
        case .equals: calculate()
        case let operation where operation.isOperator: handleOperator(operation)
        default: break
        }
        
        return state
    }
    
    func backspace() -> Display {
        guard display != "0", !reset, typing else { return state }
        display = display.count > 1 ? String(display.dropLast()) : "0"
        if !expression.isEmpty {
            expression = expression.count > 1 ? String(expression.dropLast()) : ""
        }
        return state
    }
}

private extension CalculatorManager {
    func handleDigit(_ digit: Input) {
        guard display.count < 15 else { return }
        if reset { clear() }
        display = typing ? display + digit.symbol : digit.symbol
        expression = typing ? expression + digit.symbol : (operation != nil ? expression + digit.symbol : digit.symbol)
        typing = true
    }
    
    func handleDot() {
        guard !display.contains("."), display.count < 14 else { return }
        if reset { display = "0"; reset = false }
        display += "."
        expression += "."
        typing = true
    }
    
    func handleOperator(_ opr: Input) {
        if let pending = operation, typing {
            guard let result = pending.apply(memory, value) else { error(); return }
            memory = result
            display = format(result)
        } else {
            memory = value
        }
        expression += " \(opr.symbol) "
        operation = opr
        typing = false
        reset = false
    }
    
    func calculate() {
        guard let opr = operation else { return }
        let currentValue = display
        guard let result = opr.apply(memory, value) else { error(); return }
        expression += " \(display) = \(format(result))"
        display = format(result)
        detail = "\(format(memory)) \(opr.symbol) \(currentValue)"
        memory = result
        operation = nil
        typing = false
        reset = true
        expression = ""
    }
    
    func clear() {
        display = "0"
        detail = ""
        expression = ""
        memory = .zero
        operation = nil
        typing = false
        reset = false
    }
    
    func error() {
        clear()
        display = "Error"
        reset = true
    }
    
    func format(_ value: Decimal) -> String {
        formatter.string(from: NSDecimalNumber(decimal: value)) ?? "Error"
    }
}

private extension NumberFormatter {
    func then(_ block: (NumberFormatter) -> Void) -> NumberFormatter {
        block(self)
        return self
    }
}
