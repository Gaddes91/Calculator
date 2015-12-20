//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Matthew Gaddes on 09/12/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    // This enum implements the protocol CustomStringConvertible
    private enum Op: CustomStringConvertible {
        
        // The use of brackets after the case name allows us to associate a data type with any case in an enum - this feature is specific to Swift!
        // UnaryOperation and BinaryOperation both take a function as their second parameter. This is shown by the use of the return arrow (->)
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        // Create a new case for special characters e.g. PI
        case SpecialOperands(String, Double)
        
        // Add a read-only computed property. This will turn the Op into a String, so that it can be printed to the debug console
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .SpecialOperands(let symbol, _): // Case to hold symbols and constants such as PI
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]() // Create array of type Op
    
    private var opStackOperand = [Op]() // Holds operands only
    private var opStackOperation = [Op]() // Holds operations only
    
    
    // Create dictionary to hold all known operations
    // Key:Value -> String:Op
    private var knownOps = [String:Op]()
    
    // Create our own initialiser for CalculatorBrain
    // Each time an object is initialised through the controller (e.g. let brain = CalculatorBrain()), this initialiser method will be called.
    init () {
        
        // Initialise knownOps dictionary
        // In many cases we have used the built-in Swift functions for multiplication (*), addition (+), square root (sqrt)
        // We cannot do this for division (÷) and minus (−), however, since the operations would be "popped off the stack" in the wrong order
        
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin") { sin($0 * (M_PI / 180)) }) // Convert user input from degrees to radians
        learnOp(Op.UnaryOperation("cos") { cos($0 * (M_PI / 180)) }) // Convert user input from degrees to radians
        learnOp(Op.SpecialOperands("π", M_PI))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        // This function returns a tuple, including the result and the stack of remaining ops (the ops that have not yet been consumed)
        
        // check the stack of Ops is not empty
        if !ops.isEmpty {
            
            // The argument "ops" is passed as a constant by default. Since we want to "removeLast()", we must ensure "ops" is mutable. We do this by creating a mutable copy named "remainingOps". Alternatively, we could have used the "var" keyword when defining the argument name.
            var remainingOps = ops

            // Pull the latest op off the top of the stack
            let op = remainingOps.removeLast()
            
            switch op {
            
            // Assign the associated value to a constant named "operand"
            case .Operand(let operand):
                return (operand, remainingOps)
            
            // Ignore the returned string value by using an underscore
            case .UnaryOperation(_, let operation):
                
                // Use recursion to evaluate remaining ops. "operandEvaluation" is a tuple - we can check this by option-clicking
                let operandEvaluation = evaluate(remainingOps)
                // To extract the result we use dot syntax. We also "if let", since the result is returned as an optional
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            // For this case we do the same as .UnaryOperation, except we must do it twice
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            
            case .SpecialOperands(_, let value):
                return (value, remainingOps)
            }
        }
        
        // This is the default/failure return
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        // This function returns an Optional(Double) because the user might, for example, try to evaluate an operation (+, -, etc.) before entering any operands (digits). In this case we want to return nil, otherwise the program would crash.
        
        // Use a tuple to hold the result of the recursive evaluate() function. Note that the names "result" and "remainder" do not have to match up with the names used in the recursive function
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        
        opStack.append(Op.Operand(operand)) // Append to opStack
        opStackOperand.append(Op.Operand(operand)) // Append to opStackOperand
        
        // Every time we push an operand it will return the evaluation (-> Double?)
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        
        // Whenever we look something up in a dictionary, an optional is returned. This is because we cannot be sure the thing we are looking up actually exists
        if let operation = knownOps[symbol] {
            opStack.append(operation) // Append to opStack
            opStackOperation.append(operation) // Append to opStackOperation
        }
        
        // Every time we perform an operation it will return the evaluation (-> Double?)
        return evaluate()
    }
    
    // Must be defined outside of the following function to prevent the displayHistory from resetting to "" each time the function is called
    var displayHistory = ""
    
    // Update display history to reflect the history of operands together with the operations performed upon them
    func updateDisplayHistory() -> String {
        
        /* This "if" statement confirms that opStackOperand is not empty before proceeding.
        * If the operation is performed whilst the opStackOperand is empty, the program will crash.
        */
        if !opStackOperand.isEmpty {
            
            /* If displayHistory is empty then two operands must be added to the displayHistory (both the operand before and the operand after the operator symbol itself)
            * To access the operand before the operator, we must take the penultimate value from the operand-only stack (opStackOperand.removeAtIndex(opStackOperand.count - 2))
            * To access the operand after, we simply use opStackOperand.removeLast()
            * We update displayHistory by appending each op, as a string, to the end of the existing displayHistory (displayHistory += "\(...)")
            */
            if displayHistory.isEmpty {
                // Append the operand before the operation, the operation itself and, finally, the second operand
                displayHistory += truncateOperandIfInteger("\(opStackOperand.removeAtIndex(opStackOperand.count - 2))")
                displayHistory += truncateOperandIfInteger("\(opStackOperation.removeLast())")
                displayHistory += truncateOperandIfInteger("\(opStackOperand.removeLast())")
            } else {
                // If displayHistory is not empty then our job is easier - we only have to add the operation symbol and the latest operand
                displayHistory += truncateOperandIfInteger("\(opStackOperation.removeLast())")
                displayHistory += truncateOperandIfInteger("\(opStackOperand.removeLast())")
            }
        }
        return displayHistory
    }
    
    
    // --- Number formatting functions below
    
    // Truncate display value if it is an integer
    func truncateDisplayValueIfInteger(displayVal: Double) -> String {
        
        var result = ""
        
        if displayVal % 1 == 0 { // If value can be divided exactly by 1 (i.e. it is an integer)
            let formatter = NSNumberFormatter()
            formatter.maximumFractionDigits = 0 // No decimal places allowed
            
            result = formatter.stringFromNumber(displayVal)!
            
        } else {
            result = "\(displayVal)" // Simply print the String value, with decimal points included
        }
        return result
    }
    
    // Same as above except this function takes String as an argument. Once string has been converted to Double
    private func truncateOperandIfInteger(operand: String) -> String {
        
        var result = ""
        
        // Convert String to Double and then call truncateDisplayValueIfInteger() to truncate number
        if let doubleValue = NSNumberFormatter().numberFromString(operand)?.doubleValue {
            // The return type of truncateDisplayValueIfInteger is String
            result = truncateDisplayValueIfInteger(doubleValue)
        } else {
            result = "\(operand)" // Simply print the String value, with decimal points included
        }
        
        return result
    }
    
    
}