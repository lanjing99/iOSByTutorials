//
//  ViewController.swift
//  VisualEffectTest
//
//  Created by lanjing on 3/10/16.
//  Copyright © 2016 lanjing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func blur(sender: UIBarButtonItem) {
        let blurEffect = UIBlurEffect(style: .Light)
  
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.frame
        
//        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        vibrancyEffectView.frame = imageView.frame
//        vibrancyEffectView.contentView.addSubview(view)
        
//        blurEffectView.contentView.addSubview(imageView)
//        view.addSubview(vibrancyEffectView)
//        view.addSubview(blurEffectView)
        view.insertSubview(blurEffectView, atIndex: 1)
//        blurEffectView.contentView.addSubview(imageView)
       
        
    }
}

