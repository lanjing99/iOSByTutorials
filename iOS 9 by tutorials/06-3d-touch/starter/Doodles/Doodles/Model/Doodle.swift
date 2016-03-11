/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

struct Doodle {
  let name: String
  let date: NSDate
  let image: UIImage?
  
  static var allDoodles = [
    Doodle(name: "Doggy", date: NSDate(), image: UIImage(named: "doodle1")),
    Doodle(name: "Razeware", date: NSDate(), image: UIImage(named: "doodle2")),
    Doodle(name: "House", date: NSDate(), image: UIImage(named: "doodle3"))
  ]
  
  static var sortedDoodles: [Doodle] {
    return allDoodles.sort { $0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow }
  }
  
  static func addDoodle(doodle: Doodle) {
    allDoodles.append(doodle)
    Doodle.configureDynamicShortcuts()
  }
  
  static func deleteDoodle(doodle: Doodle) {
    if let index = allDoodles.indexOf({ $0.name == doodle.name }) {
      allDoodles.removeAtIndex(index)
    }
    Doodle.configureDynamicShortcuts()
  }
    static func configureDynamicShortcuts() {
        if let mostRecentDoodle = Doodle.sortedDoodles.first {
        let shortcutType = "com.ww.doodles.share"
        let shortcutItem = UIApplicationShortcutItem(type: shortcutType, localizedTitle: "Share Latest Doodle", localizedSubtitle: mostRecentDoodle.name, icon: UIApplicationShortcutIcon(type: .Share),
        userInfo: nil)
        UIApplication.sharedApplication().shortcutItems = [ shortcutItem ]
    } else {
        UIApplication.sharedApplication().shortcutItems = []
        }
    }
}