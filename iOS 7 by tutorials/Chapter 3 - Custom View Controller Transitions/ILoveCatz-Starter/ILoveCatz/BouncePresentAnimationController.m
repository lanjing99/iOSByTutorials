//
//  BouncePresentAnimationController.m
//  ILoveCatz
//
//  Created by lanjing on 15/6/30.
//  Copyright (c) 2015年 com.razeware. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    // 2. obtain the container view
    UIView *containerView = [transitionContext containerView];
    // 3. set initial state
    CGRect screenBounds = [[UIScreen mainScreen] bounds]; toViewController.view.frame =
    CGRectOffset(finalFrame, 0, screenBounds.size.height); // 4. add the view
    [containerView addSubview:toViewController.view];
    // 5. animate
    NSTimeInterval duration =
    [self transitionDuration:transitionContext];
//    [UIView animateWithDuration:duration animations:^{
//        fromViewController.view.alpha = 0.5;
//        toViewController.view.frame = finalFrame;
//    } completion:^(BOOL finished) {
//            // 6. inform the context of completion
//        fromViewController.view.alpha = 1.0;
//        [transitionContext completeTransition:YES];
//    }];
    
    [UIView animateWithDuration:duration delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // set the state to animate to
                         fromViewController.view.alpha = 0.5;
                         toViewController.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                             // inform the context of completion
                             fromViewController.view.alpha = 1.0;
                             [transitionContext completeTransition:YES];
                     }
     ];
}
@end
