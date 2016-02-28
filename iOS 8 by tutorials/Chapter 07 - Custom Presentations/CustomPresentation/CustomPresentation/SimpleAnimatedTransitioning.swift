//
//  SimpleAnimatedTransitioning.swift
//  CustomPresentation
//
//  Created by lanjing on 2/28/16.
//  Copyright © 2016 Fresh App Factory. All rights reserved.
//

import UIKit



class SimpleAnimatedTransitioning: NSObject , UIViewControllerAnimatedTransitioning{
    
    var isPresentation = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let fromView = fromViewController.view!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let toView = toViewController.view!
        
        let containerView = transitionContext.containerView()!
        
        if isPresentation {
            containerView.addSubview(toView)
        }
        
        let animateControler = isPresentation ? toViewController : fromViewController
        let animateView = isPresentation ? toView : fromView
        
        let appearFrame = transitionContext.finalFrameForViewController(animateControler)
        var dismissedFrame = appearFrame
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        let initailFrame = isPresentation ? dismissedFrame : appearFrame
        let finalFrame = isPresentation ? appearFrame : dismissedFrame
        animateView.frame = initailFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0,
            usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0,
            options: .AllowAnimatedContent,
            animations: { () -> Void in
            animateView.frame = finalFrame
            }) { (value: Bool) -> Void in
                if !self.isPresentation {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
        }
        
        
        
    }
}

class SimpleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = SimplePresentationController(presentedViewController: presented, presentingViewController: presenting)
        return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = SimpleAnimatedTransitioning()
        animationController.isPresentation = true
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = SimpleAnimatedTransitioning()
        animationController.isPresentation = false
        return animationController
    }
    
}
