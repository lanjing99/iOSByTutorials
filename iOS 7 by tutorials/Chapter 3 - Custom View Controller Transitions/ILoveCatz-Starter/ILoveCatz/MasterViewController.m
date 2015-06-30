//
//  MasterViewController.m
//  ILoveCatz
//
//  Created by Colin Eberhardt on 22/08/2013.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Cat.h"
#import "BouncePresentAnimationController.h"
#import "ShrinkDismissAnimationController.h"

@interface MasterViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BouncePresentAnimationController *bounceAnimationController;
@property (nonatomic, strong) ShrinkDismissAnimationController *shrinkDismissAnimationController;

@end

@implementation MasterViewController
{
//    BouncePresentAnimationController *_bounceAnimationController;
}

- (NSArray *)cats {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).cats;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // see a cat image as a title
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat"]];
    self.navigationItem.titleView = imageView;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self cats].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Cat* cat = [self cats][indexPath.row];
    cell.textLabel.text = cat.title;
    return cell;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.bounceAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.shrinkDismissAnimationController;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // find the tapped cat
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Cat *cat = [self cats][indexPath.row];
        
        // provide this to the detail view
        [[segue destinationViewController] setCat:cat];
    }
    
    if ([segue.identifier isEqualToString:@"ShowAbout"]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
}


-(BouncePresentAnimationController *)bounceAnimationController
{
    if(!_bounceAnimationController)
    {
        _bounceAnimationController = [BouncePresentAnimationController new];
    }
    return _bounceAnimationController;
}

-(ShrinkDismissAnimationController *)shrinkDismissAnimationController
{
    if(!_shrinkDismissAnimationController)
    {
        _shrinkDismissAnimationController = [ShrinkDismissAnimationController new];
    }
    return _shrinkDismissAnimationController;
}
@end
       
       
       
       
       
       
       
       
       
       
       
       
