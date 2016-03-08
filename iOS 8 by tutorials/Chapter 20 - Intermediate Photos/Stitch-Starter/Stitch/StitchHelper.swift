/*
* Copyright (c) 2014 Razeware LLC
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
import Photos
import CoreGraphics

let StitchWidth = 900
let MaxPhotosPerStitch = 6

let StitchAdjustmentFormatIdentifier = "RW.stitch.adjustmentFormatID"

class StitchHelper: NSObject {
  
  // MARK: Stitch Creation
  class func createNewStitchWith(assets: [PHAsset], inCollection collection: PHAssetCollection) {
    let stitchImage = self.createStitchImageWithAssets(assets)
    var stichPlaceHolder: PHObjectPlaceholder!
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(stitchImage)
        stichPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
        let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: collection)
        assetCollectionChangeRequest?.addAssets([stichPlaceHolder])
      }) { (success,  error ) -> Void in
        let fetchResult = PHAsset.fetchAssetsWithLocalIdentifiers([stichPlaceHolder.localIdentifier], options: nil)
        let stitchAsset = fetchResult.firstObject as! PHAsset
        
        self.editStitchContentWith(stitchAsset, image: stitchImage, assets: assets)
    }
  }
  
  // MARK: Stitch Content
  class func editStitchContentWith(stitch: PHAsset, image: UIImage, assets: [PHAsset]) {
    
    let stitchJPEG = UIImageJPEGRepresentation(image, 0.9)
    let assetIDs = assets.map { asset in
      asset.localIdentifier
    }
    let assetsData = NSKeyedArchiver.archivedDataWithRootObject(assetIDs)
    stitch.requestContentEditingInputWithOptions(nil) { (contentEditingInput, _) -> Void in
      let adjustmentData = PHAdjustmentData(formatIdentifier: StitchAdjustmentFormatIdentifier, formatVersion: "1.0", data: assetsData)
      let contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput!)
      // 这句话的作用是什么？并不是保存图片，而是将图片写到一个临时的路径，类似如下：
      //"file:///private/var/mobile/Containers/Data/Application/B7DA62CA-B143-479C-8757-1DB871876AD1/tmp/RenderedContent-D081CFC7-2A15-42D4-92DF-5A8005C23EF3.JPG"
      stitchJPEG?.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
      contentEditingOutput.adjustmentData = adjustmentData
      PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        let request = PHAssetChangeRequest(forAsset: stitch)
        request.contentEditingOutput = contentEditingOutput
        }, completionHandler: nil)
      
    }
  }
  
  class func loadAssetsInStitch(stitch: PHAsset, completion: [PHAsset] -> ()) {
    let options = PHContentEditingInputRequestOptions()
    options.canHandleAdjustmentData = { adjustmentData in
        (adjustmentData.formatIdentifier == StitchCellReuseIdentifier) &&
        (adjustmentData.formatVersion == "1.0")
    }
    
    stitch.requestContentEditingInputWithOptions(options) { (contentEditingInput, _) -> Void in
//      if contentEditingInput!.adjustmentData != nil {
        let adjustmentData = contentEditingInput!.adjustmentData
        let stichAssetsID = NSKeyedUnarchiver.unarchiveObjectWithData(adjustmentData.data) as! [String]
        let stitchAssetsFetchResult = PHAsset.fetchAssetsWithLocalIdentifiers(stichAssetsID, options: nil)
        var stitchAssets: [PHAsset] = []
        stitchAssetsFetchResult.enumerateObjectsUsingBlock({ (obj, _, _) -> Void in
          stitchAssets.append(obj as! PHAsset)
        })
      completion(stitchAssets)
//        for asset in stitchAssetsFetchResult {
//          stitchAssets.append(asset)
//        }
//      }
    }
    
  }
  
  // MARK: Stitch Image Creation
  class func createStitchImageWithAssets(assets: [PHAsset]) -> UIImage {
    var assetCount = assets.count
    
    // Cap to 6 max photos
    if (assetCount > MaxPhotosPerStitch) {
      assetCount = MaxPhotosPerStitch
    }
    
    // Calculate placement rects
    let placementRects = placementRectsForAssetCount(assetCount)
    
    // Create context to draw images
    let deviceScale = UIScreen.mainScreen().scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: StitchWidth, height: StitchWidth), true, deviceScale)
    
    let options = PHImageRequestOptions()
    options.synchronous = true
    options.resizeMode = .Exact
    options.deliveryMode = .HighQualityFormat
    
    // Draw each image into their rect
    for (i, asset): (Int, PHAsset) in assets.enumerate() {
      if (i >= assetCount) {
        break
      }
      let rect = placementRects[i]
      let targetSize = CGSize(width: CGRectGetWidth(rect)*deviceScale, height: CGRectGetHeight(rect)*deviceScale)
      PHImageManager.defaultManager().requestImageForAsset(asset, targetSize:targetSize, contentMode:.AspectFill, options:options) { result, _ in
        if result!.size != targetSize {
          let croppedResult = self.cropImageToCenterSquare(result!, size:targetSize)
          croppedResult.drawInRect(rect)
        } else {
          result!.drawInRect(rect)
        }
      }
    }
    
    // Grab results
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
  }
  
  private class func placementRectsForAssetCount(count: Int) -> [CGRect] {
    var rects: [CGRect] = []
    
    var evenCount: Int
    var oddCount: Int
    if count % 2 == 0 {
      evenCount = count
      oddCount = 0
    } else {
      oddCount = 1
      evenCount = count - oddCount
    }
    
    let rectHeight = StitchWidth / (evenCount / 2 + oddCount)
    let evenWidth = StitchWidth / 2
    let oddWidth = StitchWidth
    
    for i in 0..<evenCount {
      let rect = CGRect(x: i%2 * evenWidth, y: i/2 * rectHeight, width: evenWidth, height: rectHeight)
      rects.append(rect)
    }
    
    if oddCount > 0 {
      let rect = CGRect(x: 0, y: evenCount/2 * rectHeight, width: oddWidth, height: rectHeight)
      rects.append(rect)
    }
    
    return rects
  }
  
  // Helper to crop Image if it wasn't properly cropped
  private class func cropImageToCenterSquare(image: UIImage, size: CGSize) -> UIImage {
    let ratio = min(image.size.width / size.width, image.size.height / size.height)
    
    let newSize = CGSize(width: image.size.width / ratio, height: image.size.height / ratio)
    let offset = CGPoint(x: 0.5 * (size.width - newSize.width), y: 0.5 * (size.height - newSize.height))
    let rect = CGRect(origin: offset, size: newSize)
    
    UIGraphicsBeginImageContext(size)
    image.drawInRect(rect)
    let output = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return output
  }
  
}
