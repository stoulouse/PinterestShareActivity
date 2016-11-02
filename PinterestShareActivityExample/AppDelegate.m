//
//  AppDelegate.m
//  PinterestShareActivityExample
//
//  Created by Samuel Toulouse on 10/6/13.
//  Copyright (c) 2013 Samuel Toulouse. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

#import "PinterestShareActivity.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[PinterestShareActivity setSharedClientID:@"1436990"];
	
    // init UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootViewController* rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = navigationController;
    
    // show UI
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[PDKClient sharedInstance] handleCallbackURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    return [[PDKClient sharedInstance] handleCallbackURL:url];
}

@end
