//
//  PinterestShareActivity.m
//  PinterestShareActivity
//
//  Created by Samuel Toulouse on 10/6/13.
//  Copyright (c) 2013 Samuel Toulouse. All rights reserved.
//

#import "PinterestShareActivity.h"
#import "PDKPin.h"

NSString *const PinterestShareActivityType = @"net.samlepirate.ios.PinterestShareActivity";



@interface PinterestShareActivity ()

@end


@implementation PinterestShareActivity

static NSString * PinterestShareClientID = @"";
static PinterestShareActivity* currentPinterestShareActivity = nil;

+ (void)setSharedClientID:(NSString*)clientID {
    [PDKClient configureSharedInstanceWithAppId:@"4865444153764361750"];
	PinterestShareClientID = clientID;
}
+(NSString*)sharedClientID {
	return PinterestShareClientID;
}

- (instancetype)init
{
    if (self = [super init]) {
		self.clientID = PinterestShareClientID;
    }
    return self;
}

- (instancetype)initWithPinterestClientID:(NSString*)clientID
{
    if (self = [super init]) {
        self.clientID = clientID;
        [PDKClient configureSharedInstanceWithAppId:@"4865444153764361750"];
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
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}
#endif

- (NSString *)activityTitle {
    return @"Pinterest";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"PinterestShareActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
//	if ([self.pinterest canPinWithSDK]) {
		for (id item in activityItems) {
			if ([item isKindOfClass:[NSURL class]]) {
				NSURL* url = item;
				if (!url.isFileURL)
					return YES;
			}
		}
//	}
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	self.imageURL = nil;
	self.sourceURL = nil;
	self.descriptionText = nil;
	
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.descriptionText = item;
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

- (void)performActivity {
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

- (void)performActivityInternal {
	currentPinterestShareActivity = self;
	
    [PDKPin pinWithImageURL:[NSURL URLWithString:@"https://about.pinterest.com/sites/about/files/logo.jpg"] link:[NSURL URLWithString:@"https://www.pinterest.com"] suggestedBoardName:@"Test" note:@"" withSuccess:^{
        
    } andFailure:^(NSError *error) {
        
    }];
}

- (void)activityDidFinish:(BOOL)completed {
    [super activityDidFinish:completed];
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if (currentPinterestShareActivity) {
		NSString* pinterestURL = [[NSURL URLWithString:[NSString stringWithFormat:@"pin%@://", currentPinterestShareActivity.clientID]] absoluteString];
		NSString* urlString = [url absoluteString];
		if ([urlString rangeOfString:pinterestURL].length != 0) {
			BOOL success = [urlString rangeOfString:@"pin_success=1"].length != 0;
			[currentPinterestShareActivity activityDidFinish:success];
			currentPinterestShareActivity = nil;
			return YES;
		}
	}
	return NO;
}

@end
