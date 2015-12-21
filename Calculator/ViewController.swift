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
    @IBOutlet weak var displayHistory: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    
    // This is the "green arrow" that goes from the controller to the model
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        // Implement SWITCH statement (switch digit) to cover different cases e.g. decimal point, etc.
        switch digit {
            
        case ".":
            if userIsInTheMiddleOfTypingANumber {
                if display.text?.rangeOfString(digit) != nil { // If current number already contains a decimal point
                    // Nothing happens - a second decimal point will NOT be appended to display
                } else {
                    fallthrough // Fall through to case directly below i.e. execute code in the default case
                }
            } else { // If current number does NOT contain a decimal point
                fallthrough
            }
            
        default:
            // This is the original code copied from lecture
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    var specialChars = ["π": M_PI] // For use with appendSpecial() below
    // TODO: associate M_PI with PI symbol in CalculatorBrain!
    
    @IBAction func appendSpecial(sender: UIButton) {
        let specialChar = sender.currentTitle // Assign button title (String) to constant specialChar -> use this to look up Double value in dictionary specialChars -> use Double value to update display (see below)
        
        // TODO: secondary display should contain symbol, primary display should contain double value
        if userIsInTheMiddleOfTypingANumber {
            if let char = specialChars[specialChar!] { // Use "if let" to confirm special character exists in the dictionary specialChars
                display.text = display.text! + "\(char)"
            }
        } else { // if user is NOT currently typing a number
            if let char = specialChars[specialChar!] {
                display.text = "\(char)"
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
        
        // Update displayHistory each time an operation is performed
        displayHistory.text = brain.updateDisplayHistory()
    }
    
    @IBAction func enter() {
        // Reset - if user clicks "enter" they are no longer typing a number
        userIsInTheMiddleOfTypingANumber = false
        
        
        if let value = displayValue { // Check displayValue is not nil
            if let result = brain.pushOperand(value) { // Push operand onto the stack
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    // Computed property - get string value of display (UILabel) and return optional double value
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            } else {
                return nil
            }
        }
        set {
            if let value = newValue { // Check newValue is not nil
                display.text = brain.truncateDisplayValueIfInteger(value)
            } else {
                display.text = "" // Clear display if newValue is nil
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clearAll(sender: UIButton) { // Clear all values on button press
        
        display.text = "" // Clear display
        displayHistory.text = "" // Clear displayHistory
        
        userIsInTheMiddleOfTypingANumber = false // Reset userIsInTheMiddleOfTypingANumber
        
        brain.opStack = []
        brain.opStackOperand = []
        brain.opStackOperation = []
        brain.displayHistory = ""
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

