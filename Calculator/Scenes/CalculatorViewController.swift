//
//  ViewController.swift
//  Calculator
//
//  Created by Eren Ali Koca on 13.07.2025.
//

import UIKit

final class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var calculationDetailLabel: UILabel!
    
    private let calculator = CalculatorManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        update(calculator.input(sender.tag))
    }
        
}

private extension CalculatorViewController {
    func setupUI() {
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.3
        resultLabel.isUserInteractionEnabled = true
        resultLabel.addGestureRecognizer(
            UISwipeGestureRecognizer(target: self, action: #selector(swipe))
                .then { $0.direction = .left }
        )
        update(calculator.state)
    }
    
    @objc func swipe() {
        update(calculator.backspace())
    }
    
    func update(_ display: Display) {
        resultLabel.text = display.result
        calculationDetailLabel.text = display.detail
    }
}

private extension UISwipeGestureRecognizer {
    func then(_ block: (UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        block(self)
        return self
    }
}
