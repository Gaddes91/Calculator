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
        
        // Implement SWITCH statement (switch digit) to cover different cases e.g. decimal point, etc.
        switch digit {
            
        case ".":
            if display.text?.rangeOfString(digit) != nil {
                // Nothing happens - if the display currently contains a decimal point, a second decimal point will NOT be appended to display
                
                // TODO: 1.1 - If user enters decimal point before any other number, the number "0" should be prepended to the display
                
            } else {
                fallthrough // Fall through to case directly below i.e. execute code in the default case
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

