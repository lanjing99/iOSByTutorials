//
//  BaseViewController.m
//  DropMe
//
//  Created by lanjing on 15/8/8.
//  Copyright (c) 2015年 Razeware LLC. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)displayActionButton
{
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:actionButton animated:YES];
}


-(void)hideActionButton
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

-(void)setObjectsToShare:(NSArray *)objectsToShare
{
    _objectsToShare = [objectsToShare copy];
    if([objectsToShare count])
    {
        [self displayActionButton];
    }
    else
    {
        [self hideActionButton];
    }
}

-(void)presentActivityViewControllerWithObjects:(NSArray *)objects
{
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objects applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)actionButtonTapped:(id)sender
{
    [self presentActivityViewControllerWithObjects:self.objectsToShare];
}
@end
