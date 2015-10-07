//
//  ViewController.swift
//  Calculator
//
//  Created by Jon on 10/7/15.
//  Copyright © 2015 Second Wind, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
   
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        appendToDisplay(digit)
    }
    
    @IBAction func decimal(sender: UIButton) {
        let decimalFound = display.text!.rangeOfString(".")
        if (decimalFound == nil || !userIsInTheMiddleOfTypingANumber)
        {
            if (!userIsInTheMiddleOfTypingANumber)
            {
                appendToDisplay("0.")
            } else {
                appendToDisplay(".")
            }
        }
    }
    
    @IBAction func pi() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 3.14159265359
        enter()
    }
    
    @IBAction func clear() {
        operandStack.removeAll()
        displayValue = 0
        history.text = ""
    }
    
    func appendToDisplay(name:String) {
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + name
        } else {
            display.text = name
            userIsInTheMiddleOfTypingANumber = true
        }
        history.text = history.text! + name
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        history.text = history.text! + operation
        
        switch operation {
            case "×": performOperation() { $0 * $1}
            case "÷": performOperation() { $1 / $0}
            case "+": performOperation() { $0 + $1}
            case "-": performOperation() { $1 - $0}
            case "√": performOperation() { sqrt($0)}
            case "sin" : performOperation() { sin($0)}
            case "cos" : performOperation() { cos($0)}
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }

    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
        
    }
    var operandStack: [Double] = [Double]()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        history.text = history.text! + "⏎"
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

