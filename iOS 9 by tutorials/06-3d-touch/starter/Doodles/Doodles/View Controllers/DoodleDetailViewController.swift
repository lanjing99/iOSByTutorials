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

class DoodleDetailViewController: UIViewController {
  var doodle: Doodle?
  var shareDoodle = false
    weak var doodleViewController: DoodlesViewController?
  
  @IBOutlet weak var imageView: UIImageView!
  
  private var activityViewController: UIActivityViewController? {
    guard let doodle = doodle,
      image = doodle.image else { return nil }
    
    return UIActivityViewController(activityItems: [image], applicationActivities: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let doodle = doodle {
      title = doodle.name
      imageView.image = doodle.image
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if shareDoodle == true {
      presentActivityViewController()
    }
  }
  
  @IBAction func presentActivityViewController() {
    if let activityViewController = activityViewController {
      presentViewController(activityViewController, animated: true, completion: nil)
    }
  }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share", style: .Default) { (previewAction, viewController) -> Void in
            if let doodleVC = self.doodleViewController,
                activityViewController = self.activityViewController {
                    doodleVC.presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
        
        let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive) { (previewAction, viewController) -> Void in
            guard let doodle = self.doodle else {
                return
            }
            Doodle.deleteDoodle(doodle)
            self.doodleViewController?.tableView.reloadData()
        }
        return [shareAction,  deleteAction]
    }
}












