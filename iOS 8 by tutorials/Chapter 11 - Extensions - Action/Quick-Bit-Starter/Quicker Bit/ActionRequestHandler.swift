//
//  ActionRequestHandler.swift
//  Quicker Bit
//
//  Created by lanjing on 3/2/16.
//  Copyright © 2016 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import BitlyKit

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        
        self.extensionContext = context
        let extensionItem = context.inputItems.first as? NSExtensionItem
        if extensionItem == nil {
            self.doneWithResults(nil)
            return
        }
        
        let itemProvider = extensionItem!.attachments?.first as? NSItemProvider
        if itemProvider == nil {
            self.doneWithResults(nil)
            return
        }
        
        let propertyListType = kUTTypePropertyList as NSString as String
        if itemProvider!.hasItemConformingToTypeIdentifier(propertyListType) {
            itemProvider!.loadItemForTypeIdentifier(propertyListType, options: nil){ item, error in
                let dictionary = item as! NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    self.itemLoadCompletedWithPreprocessingResults(results as [NSObject : AnyObject])
                }
                
            }
        }else{
           self.doneWithResults(nil)
        }
        
        
        
//        // Do not call super in an Action extension with no user interface
//        self.extensionContext = context
//        
//        var found = false
//        
//        // Find the item containing the results from the JavaScript preprocessing.
//        outer:
//            for item: AnyObject in context.inputItems {
//                let extItem = item as! NSExtensionItem
//                if let attachments = extItem.attachments {
//                    for itemProvider: AnyObject in attachments {
//                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
//                            itemProvider.loadItemForTypeIdentifier(String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
//                                let dictionary = item as! [String: AnyObject]
//                                NSOperationQueue.mainQueue().addOperationWithBlock {
//                                    self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [NSObject: AnyObject])
//                                }
//                                found = true
//                            })
//                            if found {
//                                break outer
//                            }
//                        }
//                    }
//                }
//        }
//        
//        if !found {
//            self.doneWithResults(nil)
//        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: [NSObject: AnyObject]) {
        let currentURLString = javaScriptPreprocessingResults["currentUrl"] as? String
        if currentURLString?.isEmpty == false {
            let bitlyService = BitlyService(accessToken: "19febc3999253ad2227019c933a224bb0d6f8480")
            if let longURL = NSURL(string: currentURLString!) {
                bitlyService.shortenUrl(longURL, domain: "bit.ly"){ shortenedURL, error in
                    if error != nil {
                        self.doneWithResults(["error" : error!.description])
                    }else{
                        let shortURL = shortenedURL!.shortUrl
                        UIPasteboard.generalPasteboard().URL = shortURL
                        let results = ["shortUrl" : shortURL?.absoluteString ?? ""]
                        
                        BitlyHistoryService.sharedService.addItem(shortenedURL!)
                        BitlyHistoryService.sharedService.persistItemsArray()
                        self.doneWithResults(results)
                    }
                    
                }
            }
        }
        
        
//        // Here, do something, potentially asynchronously, with the preprocessing
//        // results.
//        
//        // In this very simple example, the JavaScript will have passed us the
//        // current background color style, if there is one. We will construct a
//        // dictionary to send back with a desired new background color style.
//        let bgColor: AnyObject? = javaScriptPreprocessingResults["currentBackgroundColor"]
//        if bgColor == nil ||  bgColor! as! String == "" {
//            // No specific background color? Request setting the background to red.
//            self.doneWithResults(["newBackgroundColor": "red"])
//        } else {
//            // Specific background color is set? Request replacing it with green.
//            self.doneWithResults(["newBackgroundColor": "green"])
//        }
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: [NSObject: AnyObject]?) {
        
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.

            // These will be used as the arguments to the JavaScript finalize()
            // method.

            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]

            let resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: String(kUTTypePropertyList))

            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]

            // Signal that we're complete, returning our results.
            self.extensionContext!.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }

}








































