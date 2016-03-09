//
//  ViewController.swift
//  WebKitStarter
//
//  Created by lanjing on 3/9/16.
//  Copyright © 2016 lanjing. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputURLTextfield: UITextField!
    @IBOutlet weak var barBackgroundView: UIView!
    
    var webView: WKWebView
    
    
    
    required init?(coder aDecoder: NSCoder) {
        webView = WKWebView(frame: CGRectZero)
        webView.backgroundColor = UIColor.blueColor()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraint)
        
//        let verticalContrains = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView])
//        view.addConstraints(verticalContrains)
//        let horizontalContrains = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView])
//        view.addConstraints(horizontalContrains)
     
        
        inputURLTextfield.text = "http://www.baidu.com"
        let URL = NSURL(string: inputURLTextfield.text!)
        let request = NSURLRequest(URL:URL!)
        webView.loadRequest(request)
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        barBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
    }

    func cancel () {
        inputURLTextfield.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        barBackgroundView.frame = CGRect(x:0, y: 0, width:view.frame.width, height: 30)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let cancelButton = UIBarButtonItem(title: "Cancel", style:.Plain, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = cancelButton
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputURLTextfield.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        barBackgroundView.frame = CGRect(x:0, y: 0, width:view.frame.width, height: 30)
        if let string = inputURLTextfield.text {
            if let URL = NSURL(string:string){
                webView.loadRequest(NSURLRequest(URL: URL))
            }
        }
        return false
    }
}

