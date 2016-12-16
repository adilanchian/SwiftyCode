//
//  LanguageActions.swift
//  SwiftyCode
//
//  Created by Alec Dilanchian on 11/20/16.
//  Copyright © 2016 Alec Dilanchian. All rights reserved.
//

import Foundation
import UIKit

extension ExpandedViewController {
    //-- Swift --//
    func swiftLet(sender: UIButton) {
        print("swiftLet!")
    }
    
    func swiftVar(sender: UIButton) {
        print("swiftVar!")
    }
    
    func swiftFunc(sender: UIButton) {
        print("swiftFunc!")
    }
    
    func swiftClass(sender: UIButton) {
        // "class [name]:[SomeController] {\n\n}"
        let classString = "class name: SomeController {\n\n}"
        let swiftClassString = NSMutableAttributedString(string: classString)
        swiftClassString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: NSRange (
            location: 6,
            length: 4))
        
        print("swiftClass!")
        // Insert code in text view //
        stringGenerator(data: swiftClassString, type: "class")
            
        // We are now one level deeper //
        currentLevel = currentLevel + 1
    }
    
    func swiftStruct(sender: UIButton) {
        print("swiftStruct!")
    }
    
    func swiftFor(sender: UIButton) {
        print("swiftFor")
    }
    
    func swiftIf(sender: UIButton) {
        print("swiftIf")
    }
    
    func swiftWhile(sender: UIButton) {
        print("swiftWhile")
    }
}
