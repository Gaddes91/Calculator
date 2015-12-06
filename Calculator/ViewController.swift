//
//  ViewController.swift
//  Calculator
//
//  Created by Matthew Gaddes on 06/12/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Variable declaration
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        
        // Check that there are at least TWO numbers in the operandStack
        if operandStack.count >= 2 {
            
            // Multiply the last two numbers in the operandStack and update displayValue with the result
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            
            // Call enter() function
            enter()
        }
    }
    
    // MARK: Potential error: Overloading of obj-c method
    // This function has been made private to remove the error regarding the overloading of obj-c methods. If this causes an error further down the line, the keyword "private" should be removed, and the function renamed to something unique.
    private func performOperation(operation: Double -> Double) {
        
        // Check that there is at least ONE number in the operandStack
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    // Declare operandStack as an array of type double
    var operandStack: [Double] = []
    
    @IBAction func enter() {
        // Reset - if user clicks "enter" they are no longer typing a number
        userIsInTheMiddleOfTypingANumber = false
        
        // Append current digit to operandStack (double value returned from computed property displayValue)
        operandStack.append(displayValue)
        
        print("operandStack = \(operandStack)")
    }
    
    
    // Computed property - get string value of display (UILabel) and return double value
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
    
    
    
    // We do not use either of the two auto-generated functions below
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

