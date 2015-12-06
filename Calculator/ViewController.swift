//
//  ViewController.swift
//  Calculator
//
//  Created by Matthew Gaddes on 06/12/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userHasAlreadyTypedANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userHasAlreadyTypedANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userHasAlreadyTypedANumber = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

