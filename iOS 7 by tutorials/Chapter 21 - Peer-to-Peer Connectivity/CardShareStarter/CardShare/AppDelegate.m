//
//  AppDelegate.m
//  GreatExchange
//
//  Created by Christine Abernathy on 6/27/13.
//  Copyright (c) 2013 Elidora LLC. All rights reserved.
//

#import "AppDelegate.h"
NSString *const kServiceType = @"rw-cardshare";
NSString *const DataReceivedNotification = @"com.razeware.apps.CardShare:DataReceivedNotification";


@interface AppDelegate ()

@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Set appearance info
    [[UITabBar appearance] setBarTintColor:[self mainColor]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:[self mainColor]];
    
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarTintColor:[self mainColor]];
    
    
    // Initialize properties
    self.cards = [@[] mutableCopy];
    
    // Initialize any stored data
    self.myCard = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"myCard"]) {
        NSData *myCardData = [defaults objectForKey:@"myCard"];
        self.myCard = (Card *)[NSKeyedUnarchiver unarchiveObjectWithData:myCardData];
    }
    self.otherCards = [@[] mutableCopy];
    if ([defaults objectForKey:@"otherCards"]) {
        NSData *otherCardsData = [defaults objectForKey:@"otherCards"];
        self.otherCards = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:otherCardsData];
    }
    
    
    
    
    NSString *peerName = self.myCard.firstName ? : [UIDevice currentDevice].name;
    self.peerID = [[MCPeerID alloc] initWithDisplayName:peerName];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType discoveryInfo:nil session:self.session];
    [self.advertiserAssistant start];
    
    
    return YES;
}

#pragma mark - Helper methods
- (UIColor *)mainColor
{
    return [UIColor colorWithRed:28/255.0f green:171/255.0f blue:116/255.0f alpha:1.0f];
}

/*
 * Implement the setter for the user's card
 * so as to set the value in storage as well.
 */
- (void)setMyCard:(Card *)aCard
{
    if (aCard != _myCard) {
        _myCard = aCard;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Create an NSData representation
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aCard];
        [defaults setObject:data forKey:@"myCard"];
        [defaults synchronize];
    }
}

- (void)addToOtherCardsList:(Card *)card
{
    [self.otherCards addObject:card];
    // Update stored value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.otherCards];
    [defaults setObject:data forKey:@"otherCards"];
    [defaults synchronize];
}

- (void) removeCardFromExchangeList:(Card *)card
{
    NSMutableSet *cardsSet = [NSMutableSet setWithArray:self.cards];
    [cardsSet removeObject:card];
    self.cards = [[cardsSet allObjects] mutableCopy];
}


-(void)sendCardToPeer
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.myCard];
    [self.session sendData:data toPeers:[self.session connectedPeers] withMode:MCSessionSendDataReliable error:nil];
}

@end