This library provides a UIActivity subclass for Pinterest sharing. It uses the native share builder API from the official Pinterest iOS SDK for sharing.

## Usage

Follow Steps of the [Pinterest iOS SDK Getting Started instructions](https://developers.pinterest.com/ios/) to

  * Register for a Client ID
  * Add an URL Type to your iOS app (pin[ClientID]).

Add a `PinterestShareActivity` to your `UIActivityViewController`.
It accepts a string and either an image or a URL. You can also create and customize your own share builder.

``` objective-c
#import <PinterestShareActivity/PinterestShareActivity.h>

- (void)actionButtonClicked:(UIBarButtonItem*)sender {
	[PinterestShareActivity setSharedClientID:@"{YourClientID}"];

    // set up items to share, in this case some text and an image
    NSArray* activityItems = @[ @"Hello Pinterest!", [NSURL URLWithString:@"https://raw.githubusercontent.com/stoulouse/PinterestShareActivity/master/PinterestShareActivityExample/example.jpg"], [NSURL URLWithString:@"https://github.com/stoulouse/PinterestShareActivity/"] ];
    
    // set up and present activity view controller
    PinterestShareActivity* piShareActivity = [[PinterestShareActivity alloc] init];
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[piShareActivity]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // present in popup
        self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        piShareActivity.activityPopoverViewController = self.activityPopoverController;
        [self.activityPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        // present modally
        piShareActivity.activitySuperViewController = self;
        [self presentViewController:activityViewController animated:YES completion:NULL];
    }
}
```

Setting `activityPopoverViewController` or `activitySuperViewController` allows you to dismiss the popover controller or modal view controller before the Pinterest share view is shown.

## Notes

You can only share on device because you need Pinterest app installed on the phone to share.

## License

It's MIT. See LICENSE file.
