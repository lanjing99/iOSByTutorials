//
//  PinchInteractionController.m
//  ILoveCatz
//
//  Created by lanjing on 15/7/1.
//  Copyright (c) 2015年 com.razeware. All rights reserved.
//

#import "PinchInteractionController.h"

@implementation PinchInteractionController{
    BOOL _shouldCompleteTransition;
    UIViewController *_presentingViewController;
//    UINavigationController *_navigationController;
}

- (void)wireToViewController:(UIViewController *)viewController
{
//    _navigationController = viewController.navigationController;
    _presentingViewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPinchGestureRecognizer *gesture =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPinchGestureRecognizer*)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            // 1. Start an interactive transition!
            self.interactionInProgress = YES;
            [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 2. compute the current position
            float scale = gestureRecognizer.scale;
            // 3. should we complete?
            _shouldCompleteTransition = (scale < 0.5);
            NSLog(@"%f", scale);
            // 4. update the animation
            [self updateInteractiveTransition:1 - scale];
            break;
        }
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled:
            // 5. finish or cancel
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
        default:
        break; }
}


@end
