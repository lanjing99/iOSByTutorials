//
//  ViewController.m
//  DynamicsPlayground
//
//  Created by lanjing on 15/6/25.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
{
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    BOOL _isFirstContact;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    //ReferenceView坐标系参考视图，写成了square，导致冲突行为无法发生？
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[square]];
    _gravity.magnitude = 0.1;
    [_animator addBehavior:_gravity];
    
    UIView* barrier = [[UIView alloc]
                       initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[square]];
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.action = ^{
////        NSLog(@"%@, %@", NSStringFromCGAffineTransform(square.transform), NSStringFromCGPoint(square.center));
//        static int count = 0;
////        if(count++ % 5 == 0)
//        {
//            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectZero];
////            paddingView.backgroundColor = [UIColor blueColor];
//            paddingView.bounds = square.bounds;
//            paddingView.center = square.center;
//            paddingView.layer.borderColor = square.backgroundColor.CGColor;
//            paddingView.layer.borderWidth = 1;
//            paddingView.transform = square.transform;
//            [self.view addSubview:paddingView];
//        }
        
    };
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    itemBehavior.elasticity = 0.6;
    [_animator addBehavior:itemBehavior];
    
    
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSLog(@"item %@ Boundary contact occurred - %@ at point %@", item, identifier, NSStringFromCGPoint(p));
    UIView *view = (UIView *)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];
    if(!_isFirstContact)
    {
        _isFirstContact = YES;
        UIView *square = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 100)];
        square.backgroundColor = [UIColor grayColor];
        [self.view addSubview:square];
        [_collision addItem:square];
        [_gravity addItem:square];
        UIAttachmentBehavior* attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:square];
        [_animator addBehavior:attach];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    NSLog(@"item %@ end Boundary contact occurred - %@", item, identifier);
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
