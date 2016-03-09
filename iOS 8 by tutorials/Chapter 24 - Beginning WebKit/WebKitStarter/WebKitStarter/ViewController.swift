//
//  ViewController.swift
//  WebKitStarter
//
//  Created by lanjing on 3/9/16.
//  Copyright © 2016 lanjing. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var inputURLTextfield: UITextField!
    @IBOutlet weak var barBackgroundView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var stopReloadButton: UIBarButtonItem!
    
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
        webView.navigationDelegate = self
//        view.addSubview(webView)
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        view.addConstraint(heightConstraint)
        
//        let verticalContrains = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView])
//        view.addConstraints(verticalContrains)
//        let horizontalContrains = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView])
//        view.addConstraints(horizontalContrains)
     
        
        inputURLTextfield.text = "http://www.baidu.com"
        let URL = NSURL(string: inputURLTextfield.text!)
        let request = NSURLRequest(URL:URL!)
        webView.loadRequest(request)
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        progressView.setProgress(0.0, animated: false)
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
    
//    func webView(webView: WKWebView,didFailProvisionalNavigation navigation: WKNavigation, withError error:NSError) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//        presentViewController(alert, animated: true, completion: nil)
//    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
    
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
            stopReloadButton.image = webView.loading ? UIImage(named: "icon_stop") : UIImage(named: "icon_refresh")
            
            if (webView.loading == false) {
                inputURLTextfield.text = webView.URL?.absoluteString
            }
        } else if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    

    @IBAction func stopReload(sender: UIBarButtonItem) {
        if (webView.loading) {
            webView.stopLoading()
        }else{
            let request = NSURLRequest(URL:webView.URL!)
            webView.loadRequest(request)
        }
    }
    
    
}

