//
//  ShrinkDismissAnimationController.m
//  ILoveCatz
//
//  Created by lanjing on 15/7/1.
//  Copyright (c) 2015年 com.razeware. All rights reserved.
//

#import "ShrinkDismissAnimationController.h"

@implementation ShrinkDismissAnimationController


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    // 1
    toViewController.view.frame = finalFrame;
    toViewController.view.alpha = 0.5;
    // 2
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    // The actual animation will go here...
    
    // 1. Determine the intermediate and final frame for the from view
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect shrunkenFrame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width/4, fromViewController.view.frame.size.height/4);
    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // 2. animate with keyframes
    [UIView animateKeyframesWithDuration:duration delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                                     // 3a. keyframe one
                                     [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5
                                                                   animations:^{
//                                                                       fromViewController.view.frame = shrunkenFrame;
                                                                       fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                                                       toViewController.view.alpha = 0.5;
                                                                   }];
                                     // 3b. keyframe two
                                     [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5
                                                                   animations:^{
                                                                       fromViewController.view.frame = fromFinalFrame;
                                                                       toViewController.view.alpha = 1.0;
                                                                   }];
                                 }completion:^(BOOL finished) {
                                  // 4. inform the context of completion
//                                     [transitionContext completeTransition:YES];
                                     [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
                              }];
    
    
//    // create a snapshot
//    UIView *intermediateView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
//    intermediateView.frame = fromViewController.view.frame; [containerView addSubview:intermediateView];
//    // remove the real view
//    [fromViewController.view removeFromSuperview];
//    [UIView animateKeyframesWithDuration:duration delay:0.0
//                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
//                                     [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5
//                                                                   animations:^{
//                                                                       intermediateView.frame = shrunkenFrame;
//                                                                       toViewController.view.alpha = 0.5; }
//                                      ];
//                                     [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5
//                                                                   animations:^{ intermediateView.frame = fromFinalFrame;
//                                                                       toViewController.view.alpha = 1.0;
//                                                                   }
//                                      ];
//                                 }
//                              completion:^(BOOL finished) {
//                                  // remove the intermediate view
////                                  [intermediateView removeFromSuperview];  //这个语句没执行似乎也没关系。contentView是整个从父视图中被移除的。
//                                  [transitionContext completeTransition:YES];
//                              }
//     ];
}
@end
