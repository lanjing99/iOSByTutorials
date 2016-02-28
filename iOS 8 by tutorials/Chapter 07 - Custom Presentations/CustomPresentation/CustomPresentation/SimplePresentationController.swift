//
//  SimplePresentationController.swift
//  CustomPresentation
//
//  Created by lanjing on 2/28/16.
//  Copyright © 2016 Fresh App Factory. All rights reserved.
//

import UIKit

class SimplePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    var dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.alpha = 0.0
    }

    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        if let cordinator = presentedViewController.transitionCoordinator() {
            cordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.dimmingView.alpha = 1.0
                }, completion: nil);
            
        }else{
            dimmingView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let cordinator = presentedViewController.transitionCoordinator() {
            cordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 0.0
                }, completion: nil);
            
        }else{
            dimmingView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView()?.frame = containerView!.bounds
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .OverFullScreen
//        return .FullScreen
    }
}
