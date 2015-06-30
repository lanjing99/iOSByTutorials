//
//  DynamicSandwichViewController.m
//  SandwichFlow
//
//  Created by lanjing on 15/6/26.
//  Copyright (c) 2015年 Colin Eberhardt. All rights reserved.
//

#import "DynamicSandwichViewController.h"
#import "AppDelegate.h"
#import "SandwichViewController.h"

@interface DynamicSandwichViewController ()<UICollisionBehaviorDelegate>
{
    NSMutableArray* _views;
    
    UIGravityBehavior* _gravity;
    UIDynamicAnimator* _animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
    
    UISnapBehavior* _snap;
    BOOL _viewDocked;
}

@end

@implementation DynamicSandwichViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Background image
//    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:
//                                        [UIImage imageNamed:@"Background-LowerLayer.png"]];
//    [self.view addSubview:backgroundImageView];
//    // Header logo
//    UIImageView* header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sarnie.png"]];
//    header.center = CGPointMake(220, 190);
//    [self.view addSubview:header];
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-LowerLayer.png"]];
    backgroundImageView.frame = CGRectInset(self.view.frame, -50.0f, -50.0f); [self.view addSubview:backgroundImageView];
    [self addMotionEffectToView:backgroundImageView magnitude:50.0f];
    // 2. add the background mid layer
    UIImageView* midLayerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-MidLayer.png"]];
    [self.view addSubview:midLayerImageView];
    // 3. add the foreground image
    UIImageView* header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sarnie.png"]];
    header.center = CGPointMake(220, 190);
    [self.view addSubview:header];
    [self addMotionEffectToView:header magnitude:-20.0f];
    
    _views = [NSMutableArray new];
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] init];
    _gravity.magnitude = 4.0f;
    [_animator addBehavior:_gravity];
    
    CGFloat offset = 250.0f;
    for (NSDictionary* sandwich in [self sandwiches]) {
        UIView * view = [self addRecipeAtOffset:offset forSandwich:sandwich];
        [_views addObject:view];
        [self addMotionEffectToView:view magnitude:offset/5];
        offset -= 50.0f;
    }
    
}

- (NSArray*)sandwiches {
    AppDelegate* appDelegate = (AppDelegate*)
    [[UIApplication sharedApplication] delegate];
    return appDelegate.sandwiches;
}



- (UIView*)addRecipeAtOffset:(CGFloat)offset forSandwich:(NSDictionary*)sandwich {
    CGRect frameForView = CGRectOffset(self.view.bounds, 0.0, self.view.bounds.size.height - offset);
    // 1. create the view controller
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SandwichViewController* viewController = [mystoryboard instantiateViewControllerWithIdentifier:@"SandwichVC"];
    // 2. set the frame and provide some data
    UIView* view = viewController.view;
    view.frame = frameForView;
    viewController.sandwich = sandwich;
    // 3. add as a child
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    // 1. add a gesture recognizer
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:pan];
    // 2. create a collision
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:collision];
    // 3. lower boundary, where the tab rests
    CGFloat boundary = view.frame.origin.y + view.frame.size.height+1;
    CGPoint boundaryStart = CGPointMake(0.0, boundary);
    CGPoint boundaryEnd = CGPointMake(self.view.bounds.size.width,
                                      boundary);
    [collision addBoundaryWithIdentifier:@1 fromPoint:boundaryStart toPoint:boundaryEnd];
    // 4. apply some gravity
    [_gravity addItem:view];
    
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(self.view.bounds.size.width, 0.0); [collision addBoundaryWithIdentifier:@2
                                                                                            fromPoint:boundaryStart toPoint:boundaryEnd];
    collision.collisionDelegate = self;
    
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:itemBehavior];
    return view;
}


- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    UIView* draggedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 1. was the pan initiated from the top of the recipe?
    CGPoint dragStartLocation = [gesture locationInView:draggedView];
        if (dragStartLocation.y < 200.0f) {
        _draggingView = YES;
        _previousTouchPoint = touchPoint;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView) {
        // 2. handle dragging
        CGFloat yOffset = _previousTouchPoint.y - touchPoint.y;
        gesture.view.center = CGPointMake(draggedView.center.x,draggedView.center.y - yOffset);
        _previousTouchPoint = touchPoint;
    } else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView) {
        // 3. the gesture has ended
        [self tryDockView:draggedView];
        [self addVelocityToView:draggedView fromGesture:gesture];
        [_animator updateItemUsingCurrentState:draggedView];
        _draggingView = NO;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    UIView* view = (UIView*) item;
    if ([@2 isEqual:identifier])
    {
        [self tryDockView:view];
    }
    else if ([@1 isEqual:identifier])
    {
        UIView *nextView = [self nextViewOfView:view];
        if(nextView == nil) return;
        
        UIDynamicItemBehavior *currentViewItemBehavior = [self itemBehaviourForView:view];
        UIDynamicItemBehavior *nextViewItemBehavior = [self itemBehaviourForView:nextView];
        CGPoint velocity = [currentViewItemBehavior linearVelocityForItem:view];
        velocity.y *= 2;
        [nextViewItemBehavior addLinearVelocity:velocity forItem:nextView];
    }
}

- (UIDynamicItemBehavior*) itemBehaviourForView:(UIView*)view
{
    for (UIDynamicItemBehavior* behaviour in _animator.behaviors) {
        if (behaviour.class == [UIDynamicItemBehavior class] && [behaviour.items firstObject] == view)
        {
            return behaviour;
        }
    }
    return nil;
}

- (void)addVelocityToView:(UIView*)view fromGesture:(UIPanGestureRecognizer*)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
    vel.x = 0;
    UIDynamicItemBehavior* behaviour = [self itemBehaviourForView:view];
    [behaviour addLinearVelocity:vel forItem:view];
}


- (void)tryDockView:(UIView *)view {
    BOOL viewHasReachedDockLocation = view.frame.origin.y < 100.0;
    if (viewHasReachedDockLocation) {
        if (!_viewDocked) {
        _snap = [[UISnapBehavior alloc] initWithItem:view
                                         snapToPoint:self.view.center];
            [_animator addBehavior:_snap];
        [self setAlphaWhenViewDocked:view alpha:0.0];
        _viewDocked = YES;
        }
    } else {
        if (_viewDocked) {
            [_animator removeBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:1.0]; _viewDocked = NO;
        }
    }
}

- (void)setAlphaWhenViewDocked:(UIView*)view alpha:(CGFloat)alpha {
    for (UIView* aView in _views) {
        if (aView != view) {
            aView.alpha = alpha;
        }
    }
}


- (void)addMotionEffectToView:(UIView*)view magnitude:(CGFloat)magnitude
{
    UIInterpolatingMotionEffect* xMotion = [[UIInterpolatingMotionEffect alloc]
                                            initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xMotion.minimumRelativeValue = @(-magnitude);
    xMotion.maximumRelativeValue = @(magnitude);
    UIInterpolatingMotionEffect* yMotion = [[UIInterpolatingMotionEffect alloc]
                                            initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yMotion.minimumRelativeValue = @(-magnitude);
    yMotion.maximumRelativeValue = @(magnitude);
    UIMotionEffectGroup* group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotion, yMotion]; [view addMotionEffect:group];
}

-(UIView *)nextViewOfView:(UIView *)view
{
    NSUInteger index = [_views indexOfObject:view];
    if(index < _views.count - 1)
    {
        return _views[index+1];
        
    }
    return nil;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
