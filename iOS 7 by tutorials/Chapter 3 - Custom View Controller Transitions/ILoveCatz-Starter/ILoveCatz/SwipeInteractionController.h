//
//  SwipeInteractionController.h
//  ILoveCatz
//
//  Created by lanjing on 15/7/1.
//  Copyright (c) 2015年 com.razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interactionInProgress;

- (void)wireToViewController:(UIViewController*)viewController;

@end
