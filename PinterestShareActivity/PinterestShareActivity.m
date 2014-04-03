//
//  PinterestShareActivity.m
//  PinterestShareActivity
//
//  Created by Samuel Toulouse on 10/6/13.
//  Copyright (c) 2013 Samuel Toulouse. All rights reserved.
//

#import "PinterestShareActivity.h"

NSString *const PinterestShareActivityType = @"net.samlepirate.ios.PinterestShareActivity";


@interface PinterestShareActivity ()

@end


@implementation PinterestShareActivity

static NSString * PinterestShareClientID = @"";

+(void)setSharedClientID:(NSString*)clientID {
	PinterestShareClientID = clientID;
}
+(NSString*)sharedClientID {
	return PinterestShareClientID;
}

- (instancetype)init
{
    if (self = [super init]) {
		self.pinterest = [[Pinterest alloc] initWithClientId: PinterestShareClientID];
    }
    return self;
}

- (instancetype)initWithPinterestClientID:(NSString*)clientID
{
    if (self = [super init]) {
		self.pinterest = [[Pinterest alloc] initWithClientId:clientID];
    }
    return self;
}

- (void)dealloc
{
}

#pragma mark - Accessors

#pragma mark - UIActivity implementation

- (NSString *)activityType {
    return PinterestShareActivityType;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}
#endif

- (NSString *)activityTitle
{
    return @"Pinterest";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"PinterestShareActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	if ([self.pinterest canPinWithSDK]) {
		for (id item in activityItems) {
			if ([item isKindOfClass:[NSURL class]]) {
				NSURL* url = item;
				if (!url.isFileURL)
					return YES;
			}
		}
	}
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	self.imageURL = nil;
	self.sourceURL = nil;
	self.description = nil;
	
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.description = item;
        } else if ([item isKindOfClass:[NSURL class]]) {
			NSURL* url = item;
			if (!url.isFileURL) {
				if (!self.imageURL) {
					self.imageURL = url;
				} else {
					self.sourceURL = url;
				}
			}
        }
    }
}

- (void)performActivity
{
    if(self.imageURL) {
        // Dismiss activity view controller
        if (self.activityPopoverViewController) {
            // dismiss popover (iPad)
            [self.activityPopoverViewController dismissPopoverAnimated:YES];
            id <UIPopoverControllerDelegate> delegate = [self.activityPopoverViewController delegate];
            if ([delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)]) {
                [delegate popoverControllerDidDismissPopover:self.activityPopoverViewController];
            }
            // trigger auth and sharing
            [self performActivityInternal];
            
        } else if (self.activitySuperViewController) {
            // dismiss modal view controller (iPhone)
            [self.activitySuperViewController dismissViewControllerAnimated:YES completion:^(void){
                // trigger auth and sharing
                [self performActivityInternal];
            }];
            
        } else {
            // trigger auth and sharing
            [self performActivityInternal];
        }
        
    } else {
        NSLog(@"PinterestShareActivity error: no image url");
    }
    
    self.activityPopoverViewController = nil;
    self.activitySuperViewController = nil;
}

- (void)performActivityInternal
{
	[self.pinterest createPinWithImageURL:self.imageURL sourceURL: self.sourceURL description:self.description];
}

- (void)activityDidFinish:(BOOL)completed
{
    [super activityDidFinish:completed];
}


@end
