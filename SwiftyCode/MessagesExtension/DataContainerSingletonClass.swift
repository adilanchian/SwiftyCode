//
//  File.swift
//  SwiftyCode
//
//  Created by Alec Dilanchian on 11/20/16.
//  Copyright © 2016 Alec Dilanchian. All rights reserved.
//

import Foundation
import UIKit

class DataContainerSingleton {
    static let sharedInstance: DataContainerSingleton = {
        let instance = DataContainerSingleton()
        
        return instance
    }()
    
    var language: String!
    
    func setLanguage(language: String) {
        self.language = language
    }
    
    func getLanguage() -> String {
        return self.language
    }
}
