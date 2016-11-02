//
//  PinterestShareActivity.h
//  PinterestShareActivity
//
//  Created by Samuel Toulouse on 10/6/13.
//  Copyright (c) 2013 Samuel Toulouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PinterestSDK.h>

extern NSString *const PinterestShareActivityType;


// An UIActivity that opens a share dialog for Pinterest.
// Item types accepted:
//   - NSURL instances set the image URL to be shared. First instance.
//   - NSURL instances set the site source URL to be shared. Once image URL set, any instance overrides the previous one.
//   - NSString instances set the pin description to be shared. Any instance overrides the previous one.
@interface PinterestShareActivity : UIActivity

@property (strong, nonatomic) NSString* clientID;

@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* sourceURL;
@property (strong, nonatomic) NSString* descriptionText;

// Set one of these to dismiss the popover view controller (iPad) or presented view
// controller (iPhone) before initiating the Pinterest sharing
@property (weak, nonatomic) UIPopoverController* activityPopoverViewController;
@property (weak, nonatomic) UIViewController* activitySuperViewController;

-(id)initWithPinterestClientID:(NSString*)clientID;

+(void)setSharedClientID:(NSString*)clientID;
+(NSString*)sharedClientID;

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
