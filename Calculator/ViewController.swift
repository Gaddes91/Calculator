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
    
    // This is the "green arrow" that goes from the controller to the model
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        // TODO: 1.2 - Implement SWITCH statement (switch digit) to cover different cases e.g. π (pi), decimal point, etc.
        
        // If current digit entered by user contains decimal point, then check whether current display contains decimal point
        if digit == "." && display.text?.rangeOfString(digit) != nil { // TODO: 1.1 - If user enters decimal point before any other number, the number "0" should be prepended to the display
            // Nothing happens - a second decimal point will NOT be appended to display
        } else {
            // This is the original code copied from lecture
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        // Reset - if user clicks "enter" they are no longer typing a number
        userIsInTheMiddleOfTypingANumber = false
        
        // Push operand onto the stack
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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

