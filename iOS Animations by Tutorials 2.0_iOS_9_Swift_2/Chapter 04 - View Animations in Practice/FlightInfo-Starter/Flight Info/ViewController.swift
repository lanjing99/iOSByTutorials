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
import QuartzCore

//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet weak var bgImageView1: UIImageView!
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bgImageView1.hidden = true
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: CGRectOffset(view.frame, 0, 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    bgImageView1.alpha = 0
    //start rotating the flights
    changeFlightDataTo(londonToParis)
  }
  
  //MARK: custom methods
  
    func changeFlightDataTo(data: FlightData, animated:Bool = false) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    flightNr.text = data.flightNr
    gateNr.text = data.gateNr
    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo
    flightStatus.text = data.flightStatus
    bgImageView.image = UIImage(named: data.weatherImageName)
//    snowView.hidden = !data.showWeatherEffects
//    snowView.hidden = true
    if animated {
        fadeImageView(bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects)
    } else {
        bgImageView.image = UIImage(named: data.weatherImageName)
        snowView.hidden = !data.showWeatherEffects
        }
    
//    //test for alpha animation
//    UIView.animateWithDuration(1) { () -> Void in
//        if(self.bgImageView1.alpha == 0)
//        {
//            self.bgImageView.alpha = 0
//            self.bgImageView1.alpha = 1
//        }else{
//            self.bgImageView.alpha = 1
//            self.bgImageView1.alpha = 0
//        }
//        
//    }
    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis, animated: true)
    }
  }
  
    func fadeImageView(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        UIView.transitionWithView(imageView, duration: 1.0, options: .TransitionCrossDissolve, animations: {
        imageView.image = toImage
        }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: {
        self.snowView.alpha = showEffects ? 1.0 : 0.0
            }, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
  
}