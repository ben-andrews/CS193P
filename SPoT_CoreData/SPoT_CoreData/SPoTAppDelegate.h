//
//  SPoTAppDelegate.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 14/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPoTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) int networkActivityCounter;

- (void)incrementNetworkActivity;
- (void)decrementNetworkActivity;
- (void)resetNetworkActivity;

@end
