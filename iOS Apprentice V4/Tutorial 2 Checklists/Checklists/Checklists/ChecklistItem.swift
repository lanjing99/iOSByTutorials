//
//  ChecklistItem.swift
//  Checklists
//
//  Created by M.I. Hollemans on 27/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject, NSCoding{
  var text = ""
  var checked = false
  
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeBool(checked, forKey: "checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("text") as! String
        checked = aDecoder.decodeBoolForKey("checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
  func toggleChecked() {
    checked = !checked
  }
}
