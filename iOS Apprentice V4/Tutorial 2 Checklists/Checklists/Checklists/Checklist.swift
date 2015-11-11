//
//  Checklist.swift
//  Checklists
//
//  Created by lanjing on 11/11/15.
//  Copyright © 2015 lanjing. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name: String
    init(name: String) {
        self.name = name
        super.init()
    }
    
    override init() {
        name = ""
        super.init()
    }
}
