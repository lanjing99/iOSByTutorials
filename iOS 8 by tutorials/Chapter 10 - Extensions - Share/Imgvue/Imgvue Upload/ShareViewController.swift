//
//  ShareViewController.swift
//  Imgvue Upload
//
//  Created by lanjing on 3/2/16.
//  Copyright © 2016 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import Social
import ImgvueKit
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    var imageToShare : UIImage?
    
    override func viewDidLoad() {
        let items = extensionContext!.inputItems
        var itemProvider : NSItemProvider?
        
        if items.count > 0 {
            let item = items.first! as! NSExtensionItem
            if let attachments = item.attachments {
                if attachments.count > 0 {
                    itemProvider = attachments.first as? NSItemProvider
                }
            }
        }
        
        let imageType = kUTTypeImage as NSString as String
        if ((itemProvider?.hasItemConformingToTypeIdentifier(imageType)) != nil) {
            itemProvider!.loadItemForTypeIdentifier(imageType, options: nil){ item, error in
                if error == nil {
                    let url = item as! NSURL
                    let imageData = NSData(contentsOfURL: url)
                    if imageData != nil {
                        self.imageToShare = UIImage(data: imageData!)
                    }
                }else{
                    let title = "Unable to load image"
                    let message = "Please try again or choose a different image."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Bummer", style: .Cancel){ _ in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        if imageToShare == nil {
            return false
        }
        
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        shareImage()
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let configItem = SLComposeSheetConfigurationItem()
        configItem.title = "URL will be copied to clipboard"
        return [configItem]
    }

    
    func shareImage(){
        let defaultSession = ImgurService.sharedService.session
        let defaultConfig = defaultSession.configuration
        let defaultHeaders = defaultConfig.HTTPAdditionalHeaders
        let sessionID = "com.waterwood.imgvue.backgroundsession"
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(sessionID)
        config.sharedContainerIdentifier = "group.com.waterwood.swift.Imgvue"
        config.HTTPAdditionalHeaders = defaultHeaders
        
        let backgroundSession = NSURLSession(configuration: config, delegate: ImgurService.sharedService, delegateQueue: NSOperationQueue())
        let completion: (ImgurImage?, NSError?) -> () = { image, error in
            if error == nil {
                if let image = image {
                    UIPasteboard.generalPasteboard().URL = image.link
                    NSLog("Image shared: %@", (image.link?.absoluteString)!)
                }
            }else{
                NSLog("Error sharing image:%", error!)
            }
            
        }
        
        let progressCallback: (Float) -> () = { progress in
            print("upload progess for extension: \(progress)")
        }
        
        let title = contentText
//        ImgurService.sharedService.uploadImage(imageToShare!, title: title, completion: completion, progressCallback: progressCallback)
        ImgurService.sharedService.uploadImage(imageToShare!, title: title, session: backgroundSession, completion: completion, progressCallback: progressCallback)
        self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
        
    }
}






























